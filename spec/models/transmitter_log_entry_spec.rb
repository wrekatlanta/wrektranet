# == Schema Information
#
# Table name: transmitter_log_entries
#
#  id             :integer          not null, primary key
#  sign_in        :datetime
#  sign_out       :datetime
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  automation_in  :boolean          default(FALSE)
#  automation_out :boolean          default(FALSE)
#

require 'spec_helper'

describe TransmitterLogEntry do
  it "has a valid factory" do
    FactoryGirl.create(:transmitter_log_entry).should be_valid
  end

  it "cannot have a null sign_in time" do
    FactoryGirl.build(:transmitter_log_entry, sign_in: nil).should_not be_valid
  end

  it "sets sign_in to the current day" do
    tlog = FactoryGirl.build(:transmitter_log_entry, sign_in: "22:00")

    expect(tlog.sign_in.to_date).to eq(DateTime.now.to_date)
  end

  describe "sign_out time is automatically set to the correct date" do
    subject { FactoryGirl.create(:transmitter_log_entry, sign_in: "22:00") }
    
    it "gets set to current day if only time provided" do
      subject.sign_out = "23:00"
      expect(subject.sign_out.to_date).to eq(subject.sign_in.to_date)
    end

    it "gets set to the next day if sign_out earlier than sign_in " do
      subject.sign_out = "1:00"
      expect(subject.sign_out.to_date).to eq(subject.sign_in.to_date)
    end
  end
end
