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
    FactoryBot.create(:psa).should be_valid
  end

  it "is invalid without a title" do
    FactoryBot.build(:psa, title: nil).should_not be_valid
  end

  it "is invalid without a body" do
    FactoryBot.build(:psa, body: nil).should_not be_valid
  end

  it "is invalid without an expiration date" do
    FactoryBot.build(:psa, expiration_date: nil).should_not be_valid
  end

  it "is invalid if the expiration date is in the past" do
    FactoryBot.build(:psa, expiration_date: Date.yesterday).should_not be_valid
  end

  it "is invalid if the status does not fall in the provided list" do
    FactoryBot.build(:psa, status: "waht").should_not be_valid
  end

end
