# == Schema Information
#
# Table name: contest_suggestions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  date       :datetime
#  venue      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ContestSuggestion do
  it "has a valid factory" do
    FactoryGirl.create(:contest_suggestion).should be_valid
  end

  it "is invalid without a name name" do
    FactoryGirl.build(:contest_suggestion, name: nil).should_not be_valid
  end

  it "is invalid without a date" do
    FactoryGirl.build(:contest_suggestion, date: nil).should_not be_valid
  end

  it "is invalid without a venue" do
    FactoryGirl.build(:contest_suggestion, venue: nil).should_not be_valid
  end
end
