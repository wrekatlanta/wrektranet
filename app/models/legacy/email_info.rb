# == Schema Information
#
# Table name: emailinfo
#
#  id          :integer          not null, primary key
#  pid         :integer          default(0), not null
#  description :string(64)
#  addr        :string(64)
#  stafflist   :string(1)
#  annclist    :string(1)
#  updated     :timestamp        not null
#  pri         :string(1)
#

class Legacy::EmailInfo < Legacy::Base
  self.table_name = 'emailinfo'
  self.primary_key = 'id'

  belongs_to :staff, foreign_key: :pid

  # for some reason N is before Y if sorted by 'pri DESC'
  # so that's why it's ASC instead
  default_scope -> { order('pri ASC, updated DESC') }
end
