# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  eventable_id   :integer
#  eventable_type :string(255)
#  name           :string(255)
#  start_time     :datetime
#  end_time       :datetime
#  all_day        :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  public         :boolean          default(TRUE)
#

require 'spec_helper'

describe Event do
  it "has a valid factory" do
    FactoryGirl.create(:event).should be_valid
  end

  before do
    event_attrs = {
      name: "Event Title",
      start_time: Time.zone.today.beginning_of_day + 1.day + 20.hours,
      all_day: false
    }

    @event = Event.new(event_attrs)
  end

  subject { @event }

  describe "#name" do
    context "not present" do
      before { @event.name = nil }
      it { should_not be_valid }
    end
  end

  describe "#start_time" do
    context "not present" do
      before { @event.start_time = nil }
      it { should_not be_valid }
    end
  end
end
