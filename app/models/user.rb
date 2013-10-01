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

  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :registerable, :recoverable, :rememberable, :trackable, :validatable, :database_authenticatable

  devise :omniauthable, omniauth_providers: [:google_apps]

  has_many :staff_tickets, dependent: :destroy
  has_many :contests, through: :staff_tickets
  has_many :listener_tickets
  has_many :contest_suggestions, dependent: :destroy

  validates :phone,      format: /[\(\)0-9\- \+\.]{10,20}/, allow_blank: true
  validates :email,      presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :username,   presence: true, format: /[a-zA-Z]{2,8}/,
                         uniqueness: { case_sensitive: false }

  def name
    display_name.presence || [first_name, last_name].join(" ")
  end

  def admin?
    self.admin
  end

  # FIXME: make this generic
  def strip_phone
    self.phone.gsub!(/\D/, '') if self.phone
  end

  def self.find_for_googleapps_oauth(access_token, signed_in_resource = nil)
    data = access_token['info']

    if user = User.where(email: data['email']).first
      return user
    else
      # create a user with stub password
      User.create!({
        email: data['email'],
        username: data['email'][/[^@]+/],
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
end
