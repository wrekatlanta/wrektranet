# == Schema Information
#
# Table name: power_readings
#
#  id            :integer          not null, primary key
#  plate_current :float
#  plate_voltage :float
#  power_out     :float
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe PowerReading do
  pending "add some examples to (or delete) #{__FILE__}"
end
