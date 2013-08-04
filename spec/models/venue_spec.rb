# == Schema Information
#
# Table name: venues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  fax             :string(255)
#  address         :string(255)
#  send_day_offset :integer
#  notes           :text
#  created_at      :datetime
#  updated_at      :datetime
#  send_hour       :integer
#  send_minute     :integer
#

require 'spec_helper'

describe Venue do
  it "has a valid factory" do
    FactoryGirl.create(:venue).should be_valid
  end

  it "is invalid without a name name" do
    FactoryGirl.build(:venue, name: nil).should_not be_valid
  end

  describe "send_hour attribute" do
    it "is invalid below 0" do
      FactoryGirl.build(:venue, send_hour: -1).should_not be_valid
    end

    it "is invalid above 23" do
      FactoryGirl.build(:venue, send_hour: 24).should_not be_valid
    end
  end

  describe "send_minute attribute" do
    it "is invalid below 0" do
      FactoryGirl.build(:venue, send_minute: -1).should_not be_valid
    end

    it "is invalid above 59" do
      FactoryGirl.build(:venue, send_minute: 60).should_not be_valid
    end
  end
end
