# == Schema Information
#
# Table name: time_slots
#
#  id         :integer          not null, primary key
#  start_time :time
#  end_time   :time
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  reason     :string(255)
#  date       :date
#

require 'spec_helper'

describe TimeSlot do
  pending "add some examples to (or delete) #{__FILE__}"
end
