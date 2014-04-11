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
#  user_id    :integer
#  archived   :boolean          default(FALSE)
#  show       :string(255)
#

require 'spec_helper'

describe ContestSuggestion do
  let(:user) { FactoryGirl.create(:user) }

  it "has a valid factory" do
    FactoryGirl.create(:contest_suggestion).should be_valid
  end

  before do
    contest_suggestion_attrs = {
      name: "George and the Burdells",
      date: Time.zone.today.beginning_of_day + 1.day,
      venue: "Under the Couch"
    }

    @contest_suggestion = user.contest_suggestions.new(contest_suggestion_attrs)
  end

  subject { @contest_suggestion }

  describe "#name" do
    context "not present" do
      before { @contest_suggestion.name = nil }
      it { should_not be_valid }
    end
  end

  describe "#date" do
    context "not present" do
      before { @contest_suggestion.date = nil }
      it { should_not be_valid }
    end
  end

  describe "#venue" do
    context "not present" do
      before { @contest_suggestion.venue = nil }
      it { should_not be_valid }
    end
  end
end
