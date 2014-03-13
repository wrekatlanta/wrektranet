# == Schema Information
#
# Table name: staff
#
#  id              :integer          not null
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
end
