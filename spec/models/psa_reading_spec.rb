# == Schema Information
#
# Table name: psa_readings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  psa_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe PsaReading do
  it "has a valid factory" do
    FactoryGirl.create(:psa_reading).should be_valid
  end
end
