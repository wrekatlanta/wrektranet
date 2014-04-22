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
#  exec_staff             :boolean          default(FALSE)
#  user_id                :integer
#  subscribed_to_staff    :boolean
#  subscribed_to_announce :boolean
#  facebook               :string(255)
#  spotify                :string(255)
#  lastfm                 :string(255)
#

class User < ActiveRecord::Base
  include NaturalLanguageDate

  STATUSES = ["potential", "active", "inactive", "expired", "revoked"]

  # before_validation :get_ldap_data, on: :create
  # before_save :strip_phone
  before_validation :set_defaults, on: :create
  before_destroy :delete_from_ldap

  rolify

  natural_language_date_attr :birthday, :date

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
  has_many :trainees, class_name: "User", foreign_key: :user_id
  belongs_to :legacy_profile, foreign_key: :legacy_id, class_name: "Legacy::Staff"
  belongs_to :parent_op, class_name: "User", foreign_key: :user_id

  accepts_nested_attributes_for :legacy_profile

  # paperclip attachment for user avatars
  attr_accessor :delete_avatar
  before_validation { avatar.clear if delete_avatar == '1' }
  has_attached_file :avatar,
    styles: { medium: "300x300>", small: "100x100>", thumb: "32x32>" },
    default_url: "/images/default_:style.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

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

  attr_accessor :mark_as_inactive
  before_validation { self.status = 'inactive' if mark_as_inactive == '1' }

  # gives method names like #is_active?, is_inactive?, etc.
  STATUSES.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  def name
    if persisted?
      display_name.presence || first_name + " " + last_name
    end
  end

  def username_with_name
    username + " - " + name
  end

  def name_with_username
    name + " - " + username
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
  ## this one can be deprecated soon since migrations are coming from staff table
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

  def sync_to_ldap(new_password = nil)
    if Rails.env.production?
      ldap_handle = LdapHelper::ldap_connect

      dn = "cn=#{self.username},ou=People,dc=staff,dc=wrek,dc=org"

      pwd = new_password || self.password

      if pwd.blank?
        return false
      else
        userpassword = Net::LDAP::Password.generate(:sha, pwd)
      end

      if not LdapHelper::find_user(self.username)
        # add an ldap entry

        # build user attributes in line with the LDAP 'schema'
        user_attr = {
          cn: self.username,
          objectclass: "inetOrgPerson",
          displayname: self.name,
          mail: "#{self.username}@wrek.org",
          givenname: self.first_name,
          sn: self.last_name,
          userpassword: userpassword
        }

        unless ldap_handle.add(dn: dn, attributes: user_attr)
          puts ldap_handle.get_operation_result
          return false
        end
      else
        # modify an existing ldap entry
        ops = [
          [:replace, :cn, self.username],
          [:replace, :mail, "#{self.username}@wrek.org"],
          [:replace, :display_name, self.name],
          [:replace, :givenname, self.first_name],
          [:replace, :sn, self.last_name],
          [:replace, :userpassword, userpassword]
        ]

        ldap_handle.modify(dn: dn, operations: ops)

        unless ldap_handle.modify(dn: dn, operations: ops)
          puts ldap_handle.get_operation_result
          return false
        end
      end
    end

    # if you made it this far, success!
    true
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

  # syncs to legacy_profile (Legacy::Staff)
  # DON'T PUT THIS IN A CALLBACK because of the sync script
  # password needs to be passed in separately because the user will have already been updated
  def sync_to_legacy_profile!(new_password = nil)
    p = self.legacy_profile

    # FIXME: don't bother adding missing legacy_profiles just yet
    if self.legacy_profile.blank?
      return true
    end

    if not self.email.blank?
      if not p.emails.blank?
        email = p.emails.first
      else
        email = Legacy::EmailInfo.new(pid: p.id)
      end

      email.addr = self.email
      email.stafflist = self.subscribed_to_staff ? 'y' : 'n'
      email.annclist = self.subscribed_to_announce ? 'y' : 'n'
      email.pri = 'Y'
      email.description = 'Default, synced from WREKtranet2'

      email.save!
    end

    pwd = new_password || self.password

    p.password = pwd unless pwd.blank?
    p.initials = username
    p.admin = admin ? "y" : "n"
    p.fname = first_name
    p.mname = middle_name
    p.lname = last_name

    unless self.roles.blank?
      p.position = self.roles.map(&:full_name).join(', ')
    end

    p.save!

    # exec is a reserved word, has to be done separately
    p.update_column :exec, exec_staff ? "y" : "n"
  end

  # disable devise's uniqueness & presence validation for email
  # http://stackoverflow.com/questions/17712662/rails-3-2-devise-signup-breaks-when-name-or-email-not-unique-or-email-is-fake
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def serializable_hash(options={})
    options = { 
      methods: [:name]
    }.update(options)
    super(options)
  end
end
