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
  describe "factory" do
    subject { FactoryGirl.create(:venue) }
    it { should be_valid }
  end

  before {
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
  }

  subject { @venue }

  context "when name is not present" do
    before { @venue.name = nil }
    it { should_not be_valid }
  end

#  it "is invalid without a name" do
#    @venue.
#    FactoryGirl.build(:venue, name: nil).should_not be_valid
#  end
#
#  describe "send_hour attribute" do
#    it "is invalid below 0" do
#      FactoryGirl.build(:venue, send_hour: -1).should_not be_valid
#    end
#
#    it "is invalid above 23" do
#      FactoryGirl.build(:venue, send_hour: 24).should_not be_valid
#    end
#  end
end
