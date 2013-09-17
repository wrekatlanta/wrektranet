# == Schema Information
#
# Table name: contests
#
#  id                     :integer          not null, primary key
#  venue_id               :integer
#  age_limit              :integer
#  pick_up                :boolean
#  listener_ticket_limit  :integer
#  staff_ticket_limit     :integer
#  notes                  :text
#  created_at             :datetime
#  updated_at             :datetime
#  listener_plus_one      :boolean          default(FALSE)
#  staff_plus_one         :boolean          default(FALSE)
#  send_time              :datetime
#  sent                   :boolean          default(FALSE)
#  staff_count            :integer
#  listener_count         :integer
#  alternate_recipient_id :integer
#

require 'spec_helper'

describe Contest do
  it "has a valid factory" do
    FactoryGirl.create(:contest).should be_valid
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
      subject.staff_tickets << FactoryGirl.build_list(:staff_ticket, 3, :awarded, contest: subject)
      subject.should be_valid
    end

    it "is invalid over the limit" do
      subject.staff_tickets << FactoryGirl.create_list(:staff_ticket, 4, contest: subject)
      subject.staff_tickets << FactoryGirl.create_list(:staff_ticket, 3, :awarded, contest: subject)
      staff_ticket = FactoryGirl.build(:staff_ticket, :awarded, contest: subject)
      staff_ticket.should_not be_valid
    end
  end

  describe "listener ticket limit" do
    subject { FactoryGirl.create(:contest, listener_ticket_limit: 3) }

    it "should be valid under the limit" do
      subject.listener_tickets << FactoryGirl.build_list(:listener_ticket, 3)
      subject.should be_valid
    end

    it "is invalid over the limit" do
      subject.listener_tickets << FactoryGirl.create_list(:listener_ticket, 3, contest: subject)
      subject.listener_tickets.size.should eq 3

      listener_ticket = FactoryGirl.build(:listener_ticket, contest: subject)
      listener_ticket.should_not be_valid
    end
  end

  describe "#send_time" do
    let(:venue) { FactoryGirl.create(:venue, send_day_offset: 2, send_hour: 17) }
    subject { FactoryGirl.create(:contest, date: Time.zone.today.beginning_of_day + 1.day + 17.hours, venue: venue) }

    its(:send_time) { should eq (Time.zone.today.beginning_of_day + 1.day - 2.days + 17.hours) }
  end
end
