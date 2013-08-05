# == Schema Information
#
# Table name: contests
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  date                  :datetime
#  venue_id              :integer
#  age_limit             :integer
#  pick_up               :boolean
#  listener_ticket_limit :integer
#  staff_ticket_limit    :integer
#  notes                 :text
#  created_at            :datetime
#  updated_at            :datetime
#  listener_plus_one     :boolean
#  staff_plus_one        :boolean
#  send_time             :datetime
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
    FactoryGirl.build(:contest, listener_ticket_limit: -1).should_not be_valid
  end

  it "is invalid with a negative amount of staff tickets" do
    FactoryGirl.build(:contest, staff_ticket_limit: -1).should_not be_valid
  end

  describe "staff ticket limit" do
    subject { FactoryGirl.create(:contest, staff_ticket_limit: 3) }

    it "should be valid under the limit" do
      subject.staff_tickets << FactoryGirl.build_list(:staff_ticket, 3)
      subject.should be_valid
    end

    it "is invalid over the limit" do
      subject.staff_tickets << FactoryGirl.create_list(:staff_ticket, 4)
      subject.should_not be_valid
    end
  end

  describe "listener ticket limit" do
    subject { FactoryGirl.create(:contest, listener_ticket_limit: 3) }

    it "should be valid under the limit" do
      subject.listener_tickets << FactoryGirl.build_list(:listener_ticket, 3)
      subject.should be_valid
    end

    it "is invalid over the limit" do
      subject.listener_tickets << FactoryGirl.create_list(:listener_ticket, 4)
      subject.should_not be_valid
    end
  end

  describe "#send_time" do
    let(:venue) { FactoryGirl.create(:venue, send_day_offset: 2, send_hour: 17, send_minute: 30) }
    subject { FactoryGirl.create(:contest, date: Time.zone.today.beginning_of_day + 1.day + 17.hours, venue: venue) }

    its(:send_time) { should eq (Time.zone.today.beginning_of_day + 1.day - 2.days + 17.hours + 30.minutes) }
  end
end
