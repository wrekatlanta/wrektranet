# == Schema Information
#
# Table name: listener_logs
#
#  id         :integer          not null, primary key
#  hd2_128    :integer
#  main_128   :integer
#  main_24    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ListenerLog do
  it "has a valid factory" do
    FactoryBot.create(:listener_log).should be_valid
  end

  it "validates presence of main_128" do
    FactoryBot.build(:listener_log, main_128: nil).should_not be_valid
  end

  it "validates presence of main_24" do
    FactoryBot.build(:listener_log, main_24: nil).should_not be_valid
  end

  it "validates presence of hd2_128" do
    FactoryBot.build(:listener_log, hd2_128: nil).should_not be_valid
  end
end
