# == Schema Information
#
# Table name: phoneinfo
#
#  id          :integer          not null, primary key
#  pid         :integer          default(0), not null
#  description :string(32)
#  number      :string(32)
#  updated     :timestamp        not null
#  pri         :string(1)
#

class Legacy::PhoneInfo < Legacy::Base
  self.table_name = 'phoneinfo'
  self.primary_key = 'id'

  belongs_to :staff, foreign_key: :pid

  default_scope -> { order('pri DESC, updated DESC') }
end
