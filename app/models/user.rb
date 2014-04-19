# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)      not null
#  phone                  :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  display_name           :string(255)
#  status                 :string(255)
#  admin                  :boolean          default(FALSE)
#  buzzcard_id            :integer
#  buzzcard_facility_code :integer
#  legacy_id              :integer
#  remember_token         :string(255)
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  middle_name            :string(255)
#  birthday               :date
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  user_id                :integer
#  exec_staff             :boolean
#

class User < ActiveRecord::Base
  include NaturalLanguageDate

  STATUSES = ["potential", "active", "inactive", "expired", "revoked"]

  before_validation :get_ldap_data, on: :create
  before_validation :set_defaults, on: :create
  # before_save :strip_phone
  before_create :add_to_ldap
  before_destroy :delete_from_ldap

  rolify

  natural_language_date_attr :birthday_date, :date

  devise :registerable, :recoverable, :rememberable, :trackable,
    :validatable, :invitable, :timeoutable

  if Rails.env.production?
    devise :ldap_authenticatable
  else
    devise :database_authenticatable
  end

  has_many :staff_tickets, dependent: :destroy
  has_many :contests, through: :staff_tickets
  has_many :listener_tickets
  has_many :contest_suggestions, dependent: :destroy
  belongs_to :legacy_profile, foreign_key: :legacy_id, primary_key: :id, class_name: "Legacy::Staff"
  belongs_to :parent_op, class_name: "User", foreign_key: :user_id

  accepts_nested_attributes_for :legacy_profile

  # paperclip attachment for user avatars
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" },
    default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # commented out due to issues with legacy data
  # not all valid phone numbers
  # validates :phone,      format: /[\(\)0-9\- \+\.]{10,20}/, allow_blank: true

  # some people don't have emails, use: username@fake.me
  validates :email,      presence: true

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :username,   presence: true,
                         uniqueness: { case_sensitive: false }
  validates :status, inclusion: { in: STATUSES }

  default_scope -> { order('username ASC') }

  def name
    display_name.presence || first_name + " " + last_name
  end

  def username_with_name
    username + " - " + name
  end

  def admin?
    self.admin
  end

  def exec_staff?
    self.exec_staff
  end

  # FIXME: these role methods should probably be refactored
  def exec?(roles = [:contest_director, :psa_director])
    roles = [roles] unless roles.kind_of? Array

    result = self.admin?

    if result
      true
    else
      roles.each do |role|
        result ||= self.has_role?(role) 
      end
    end

    return result
  end

  alias_method :has_role_or_admin?, :exec?

  def authorize_exec!(roles = [:contest_director])
    unless self.exec?(roles)
      raise CanCan::AccessDenied
    end
  end

  def contest_director?
    self.exec?([:contest_director])
  end

  def psa_director?
    self.exec?([:psa_director])
  end

  def remember_value
    self.remember_token ||= Devise.friendly_token
  end

  def strip_phone
    self.phone.gsub!(/\D/, '') if self.phone
  end

  def set_defaults
    self.status ||= "potential"
    self.remember_value
  end


  ## LDAP STUFF
  def get_ldap_data
    if Rails.env.production?
      result = LdapHelper::find_user(self.username)

      if result
        self.legacy_id    ||= result.try(:employeeNumber).try(:first)
        self.first_name   ||= result.try(:givenName).try(:first)
        self.last_name    ||= result.try(:sn).try(:first)
        self.display_name ||= result.try(:displayName).try(:first)
        self.status       ||= result.try(:employeeType).try(:first) || "potential"
        self.email        ||= result.try(:mail).try(:first) || "#{username}@fake.me"
      end
    end
  end

  def add_to_ldap
    if Rails.env.production? and not LdapHelper::find_user(self.username)
      ldap_handle = LdapHelper::ldap_connect

      # Build user attributes in line with the LDAP 'schema'
      dn = "cn=#{self.username},ou=People,dc=staff,dc=wrek,dc=org"
      user_attr = {
        cn: self.username,
        objectclass: "inetOrgPerson",
        displayname: self.name,
        mail: self.email,
        employeenumber: "-1",
        givenname: self.first_name,
        sn: self.last_name,
        userpassword: "{SHA}#{Digest::SHA1.base64digest self.password}"
      }

      unless ldap_handle.add(dn: dn, attributes: user_attr)
        puts ldap_handle.get_operation_result
        return false
      end
    end
  end

  def delete_from_ldap
    if Rails.env.production?
      ldap_handle = LdapHelper::ldap_connect

      dn = "cn=#{self.username},ou=People,dc=staff,dc=wrek,dc=org"

      unless ldap_handle.delete(dn: dn)
        puts ldap_handle.get_operation_result
        return false
      end

    end
  end

  # syncs to legacy_profile
  def sync_to_legacy_profile

  end

  # disable devise's uniqueness & presence validation for email
  # http://stackoverflow.com/questions/17712662/rails-3-2-devise-signup-breaks-when-name-or-email-not-unique-or-email-is-fake
  def email_required?
    false
  end

  def email_changed?
    false
  end

  # http://stackoverflow.com/questions/10532032/devise-allow-users-to-register-as-username-but-login-with-username
  # let people login with username or email, case insensitive
  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def serializable_hash(options={})
    options = { 
      methods: [:name]
    }.update(options)
    super(options)
  end
end
