# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(128)      default(""), not null
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
#

class User < ActiveRecord::Base
  before_save :strip_phone
  after_update :sync_to_google_apps

  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :registerable, :recoverable, :rememberable, :trackable,
    :validatable, :database_authenticatable

  devise :omniauthable, omniauth_providers: [:google_apps]

  has_many :staff_tickets, dependent: :destroy
  has_many :contests, through: :staff_tickets
  has_many :listener_tickets
  has_many :contest_suggestions, dependent: :destroy

  default_scope -> { order('username ASC') }

  validates :phone,      format: /[\(\)0-9\- \+\.]{10,20}/, allow_blank: true
  validates :email,      presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :username,   presence: true, format: /[a-zA-Z]{2,8}/,
                         uniqueness: { case_sensitive: false }

  def name
    display_name.presence || [first_name, last_name].join(" ")
  end

  def username_with_name
    username + " - " + name
  end

  def admin?
    self.admin
  end

  def exec?(roles = [:contest_director])
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

  # FIXME: make this generic
  def strip_phone
    self.phone.gsub!(/\D/, '') if self.phone
  end

  def sync_to_google_apps
    if Rails.env.production?
      client = GoogleAppsHelper.create_client
      directory = client.discovered_api('admin', 'directory_v1')
      client.execute(
        api_method: directory.users.patch,
        parameters: {
          userKey: self.username + '@wrek.org'
        },
        body_object: {
          name: {
            familyName: self.last_name,
            givenName: self.first_name
          },
          phones: [
            {
              primary: true,
              type: "mobile",
              value: self.phone.presence || ''
            }
          ]
        }
      )
    end
  end

  def self.find_by_username(username)
    User.where("lower(username) = ?", username.downcase).first
  end

  def self.find_for_googleapps_oauth(access_token, signed_in_resource = nil)
    data = access_token['info']
    username = data['email'][/[^@]+/]

    if user = User.find_by_username(username)
      return user
    else
      # create a user with stub password
      User.create!({
        email: data['email'],
        username: username,
        first_name: data['first_name'],
        last_name: data['last_name'],
        password: Devise.friendly_token[0,20]
      })
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.googleapps_data'] && session['devise.googleapps_data']['user_info']
        user.email = data['email']
      end
    end
  end

  def serializable_hash(options={})
    options = { 
      methods: [:name]
    }.update(options)
    super(options)
  end
end
