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
  let(:venue) { FactoryGirl.create(:venue) }
  let(:alternate_recipient) { FactoryGirl.create(:venue) }
  let(:event) {
    FactoryGirl.create(:event,
      start_time: Time.zone.today.beginning_of_day + 1.day + 17.hours
    )
  }

  it "has a valid factory" do
    FactoryGirl.create(:contest).should be_valid
  end

  before do
    contest_attrs = {
      event: event,
      age_limit: 18,
      listener_ticket_limit: 3,
      listener_plus_one: true,
      staff_ticket_limit: 3,
      staff_plus_one: true,
      notes: "contest notes."
    }

    @contest = venue.contests.new(contest_attrs)
  end

  subject { @contest }

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

  describe "#set_send_time" do
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
  end
end
