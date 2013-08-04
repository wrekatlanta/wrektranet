# == Schema Information
#
# Table name: venues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  fax             :string(255)
#  address         :string(255)
#  send_day_offset :integer
#  send_time       :time
#  notes           :text
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Venue do
  pending "add some examples to (or delete) #{__FILE__}"
end
