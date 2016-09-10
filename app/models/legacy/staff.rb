# == Schema Information
#
# Table name: staff
#
#  id              :integer          not null, primary key
#  pfname          :string(32)
#  fname           :string(32)
#  mname           :string(32)
#  lname           :string(32)
#  birthday        :date
#  private         :text
#  public          :text
#  position        :string(128)
#  officehours     :string(128)
#  initials        :string(8)        default(""), not null
#  status          :string(9)
#  standing        :string(10)
#  contestprivs    :string(3)        default("no"), not null
#  sublist         :text
#  password        :string(16)
#  admin           :string(1)
#  exec            :string(1)
#  joined          :date
#  updated         :timestamp        not null
#  md_privileges   :integer          default(0)
#  auto_privileges :integer          default(0)
#  specialtyshow   :text
#  buzzcard_id     :integer
#  buzzcard_fc     :integer
#  door1_access    :string(1)
#  door2_access    :string(1)
#  door3_access    :string(1)
#  door4_access    :string(1)
#

class Legacy::Staff < Legacy::Base
  self.table_name = 'staff'
  self.primary_key = 'id'

  has_many :emails, foreign_key: :pid, class_name: "EmailInfo", dependent: :destroy
  has_many :phone_numbers, foreign_key: :pid, class_name: "PhoneInfo", dependent: :destroy
  has_many :team_memberships, dependent: :destroy
  has_many :show_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :shows, through: :show_memberships
  has_one :user, foreign_key: :legacy_id

  def legacy_hash(value)
    return self.class.legacy_password_hash(value)
  end

  def password=(value)
    write_attribute(:password, self.class.legacy_password_hash(value))
  end

  def serializable_hash(options={})
    options = { 
      except: [:exec]
    }.update(options)
    super(options)
  end

  # MySQL old_password polyfill
  # 
  # This is the same hashing function as used in Wrektranet1.
  #
  # https://github.com/joerghaubrichs/Ruby-MySQL-old_password-function/blob/master/mysql_password.rb
  def self.legacy_password_hash(string)
    nr = 1345345333
    nr2 = 0x12345671
    add = 7

    string.each_char do |char|
      if (char == ' ' or char == '\t')
        next
      end
      tmp = char.ord
      nr ^= (((nr & 63) + add) * tmp) + (nr << 8)
      nr2 += (nr2 << 8) ^ nr
      add += tmp
    end

    res1 = nr & 0x7fffffff
    res2 = nr2 & 0x7fffffff

    return '%08x%08x' % [res1, res2]
  end
end
