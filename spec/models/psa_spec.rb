# == Schema Information
#
# Table name: psas
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  body            :text
#  status          :string(255)
#  expiration_date :date
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Psa do
  it "has a valid factory" do
    FactoryGirl.create(:psa).should be_valid
  end

  it "is invalid without a title" do
    FactoryGirl.build(:psa, title: nil).should_not be_valid
  end

  it "is invalid without a body" do
    FactoryGirl.build(:psa, body: nil).should_not be_valid
  end

  it "is invalid without an expiration date" do
    FactoryGirl.build(:psa, expiration_date: nil).should_not be_valid
  end

  it "is invalid if the expiration date is in the past" do
    FactoryGirl.build(:psa, expiration_date: Date.yesterday).should_not be_valid
  end

  it "is invalid if the status does not fall in the provided list" do
    FactoryGirl.build(:psa, status: "waht").should_not be_valid
  end

end
