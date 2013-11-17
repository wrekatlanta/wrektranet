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
#  name                   :string(255)
#  start_time             :datetime
#  public                 :boolean          default(TRUE)
#  google_event_id        :string(255)
#

require 'spec_helper'

describe Contest do
  let(:venue) { FactoryGirl.create(:venue) }
  let(:alternate_recipient) { FactoryGirl.create(:venue) }
  let(:staff_ticket_limit) { 3 }
  let(:listener_ticket_limit) { 3 }

  it "has a valid factory" do
    FactoryGirl.create(:contest).should be_valid
  end

  before do
    contest_attrs = {
      name: "Event Title",
      start_time: Time.zone.today.beginning_of_day + 1.day + 17.hours,
      age_limit: 18,
      listener_ticket_limit: listener_ticket_limit,
      listener_plus_one: true,
      staff_ticket_limit: staff_ticket_limit,
      staff_plus_one: true,
      notes: "contest notes."
    }

    @contest = venue.contests.new(contest_attrs)
  end

  subject { @contest }

  describe "#name" do
    context "not present" do
      before { @contest.name = nil }
      it { should_not be_valid }
    end
  end

  describe "#start_time" do
    context "not present" do
      before { @contest.start_time = nil }
      it { should_not be_valid }
    end
  end

  describe "#age_limit" do
    context "not present" do
      before { @contest.age_limit = nil }
      it { should_not be_valid }
    end
  end

  describe "#listener_ticket_limit" do
    context "below 0" do
      before { @contest.listener_ticket_limit = -1 }
      it { should_not be_valid }
    end
  end

  describe "#staff_ticket_limit" do
    context "below 0" do
      before { @contest.staff_ticket_limit = -1 }
      it { should_not be_valid }
    end
  end

  describe "#update_send_time" do
    let(:venue) { FactoryGirl.create(:venue, send_day_offset: 2, send_hour: 17) }

    before do
      @contest.venue = venue
      @contest.save
    end

    context "#before_save" do
      its(:send_time) {
        should eq (Time.zone.today.beginning_of_day + 1.day - 2.days + 17.hours)
      }
    end

    context "after venue changes" do
      before do
        venue.send_day_offset = 0
        venue.send_hour = 15
        venue.save
      end

      its(:send_time) {
        should eq (Time.zone.today.beginning_of_day + 1.day + 15.hours)
      }
    end
  end

  describe "#announceable?" do
    context "before contest has been sent" do
      context "when send time is at least today" do
        before { @contest.update_send_time }
        its(:announceable?) { should be_true }
      end

      context "when send time is before today" do
        before do
          @contest.start_time = Time.zone.today.beginning_of_day - 1.day
          @contest.update_send_time
        end

        its(:announceable?) { should be_false }
      end
    end

    context "after contest has been sent" do
      before { @contest.sent = true }
      its(:announceable?) { should be_false }
    end
  end

  describe "#recipient" do
    context "with no alternate recipient" do
      its(:recipient) { should eq venue }
    end

    context "with an alternate recipient" do
      before { @contest.alternate_recipient = alternate_recipient }
      its(:recipient) { should eq alternate_recipient }
    end
  end
end
