# == Schema Information
#
# Table name: venues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  address         :string(255)
#  send_day_offset :integer
#  notes           :text
#  created_at      :datetime
#  updated_at      :datetime
#  send_hour       :integer
#

require 'spec_helper'

describe Venue do
  it "has a valid factory" do
    FactoryGirl.create(:venue).should be_valid
  end

  before do
    venue_attrs = {
      name: "Variety Playhouse",
      address: (Faker::Address.street_address +
        " "  + Faker::Address.city +
        ", " + Faker::Address.state_abbr),
      send_day_offset: 0,
      send_hour: 17,
      notes: "Venue notes."
    }

    @venue = Venue.new(venue_attrs)
  end

  subject { @venue }

  describe "#name" do
    context "not present" do
      before { @venue.name = nil }
      it { should_not be_valid }
    end
  end

  describe "#send_hour" do
    context "not present" do
      before { @venue.send_hour = nil }
      it { should_not be_valid }
    end

    context "below 0" do
      before { @venue.send_hour = -1 }
      it { should_not be_valid }
    end

    context "above 23" do
      before { @venue.send_hour = 24 }
      it { should_not be_valid }
    end
  end

  describe "#send_day_offset" do
    context "not present" do
      before { @venue.send_day_offset = nil }
      it { should_not be_valid }
    end
  end
end
