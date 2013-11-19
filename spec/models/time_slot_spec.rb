# == Schema Information
#
# Table name: time_slots
#
#  id         :integer          not null, primary key
#  start_time :datetime
#  end_time   :datetime
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  reason     :string(255)
#

require 'spec_helper'

describe TimeSlot do
  pending "add some examples to (or delete) #{__FILE__}"
end
