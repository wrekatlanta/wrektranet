require 'spec_helper'

describe ListenerLog do
  it "has a valid factory" do
    FactoryGirl.create(:listener_log).should be_valid
  end

  it "validates presence of main_128" do
    FactoryGirl.build(:listener_log, main_128: nil).should_not be_valid
  end

  it "validates presence of main_24" do
    FactoryGirl.build(:listener_log, main_24: nil).should_not be_valid
  end

  it "validates presence of hd2_128" do
    FactoryGirl.build(:listener_log, hd2_128: nil).should_not be_valid
  end
end
