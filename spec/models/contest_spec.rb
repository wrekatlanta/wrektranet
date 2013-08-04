# == Schema Information
#
# Table name: contests
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  date             :datetime
#  venue_id         :integer
#  age_limit        :integer
#  pick_up          :boolean
#  listener_tickets :integer
#  staff_tickets    :integer
#  notes            :text
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Contest do
  it "has a valid factory" do
    FactoryGirl.create(:contest).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:contest, name: nil).should_not be_valid
  end

  it "is invalid without a date" do
    FactoryGirl.build(:contest, date: nil).should_not be_valid
  end

  it "is invalid with a negative age limit" do
    FactoryGirl.build(:contest, age_limit: -1).should_not be_valid
  end

  it "is invalid with a negative amount of listener tickets" do
    FactoryGirl.build(:contest, listener_tickets: -1).should_not be_valid
  end

  it "is invalid with a negative amount of staff tickets" do
    FactoryGirl.build(:contest, staff_tickets: -1).should_not be_valid
  end
end
