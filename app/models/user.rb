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
#  admin                  :boolean
#  buzzcard_id            :integer
#  buzzcard_facility_code :integer
#

class User < ActiveRecord::Base
  rolify

  before_save :strip_phone
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :registerable, :recoverable, :rememberable, :trackable, :validatable

  if YAML.load(ENV["USE_LDAP"])
    devise :devise_ldap_authenticatable
  else
    devise :database_authenticatable
  end

  def name
    display_name.presence || [first_name, last_name].join(" ")
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :display_name, :phone

  validates :phone,      :format => /[\(\)0-9\- \+\.]{10,20}/, :allow_blank => true
  validates :email,      :presence => true, :uniqueness => true,
                         :format => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name, :presence => true
  validates :last_name,  :presence => true
  validates :username,   :presence => true, :format => /[a-zA-Z]{2,8}/,
                         :uniqueness => { :case_sensitive => false }
  validates :password,   :length => { :within => 8..40 }

  # FIXME: make this generic
  def strip_phone
    self.phone.gsub!(/\D/, '') if self.phone
  end
end
