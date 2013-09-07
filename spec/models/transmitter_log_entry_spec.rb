require 'spec_helper'

describe TransmitterLogEntry do
  it "has a valid factor" do
    FactoryGirl.create(:transmitter_log_entry).should be_valid
  end
end
