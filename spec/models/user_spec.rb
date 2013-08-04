# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(128)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)      not null
#  phone                  :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  display_name           :string(255)
#  status                 :string(255)
#  admin                  :boolean
#  buzzcard_id            :integer
#  buzzcard_facility_code :integer
#

require 'spec_helper'

describe User do
  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end

  it "is invalid without a first name" do
    FactoryGirl.build(:user, first_name: nil).should_not be_valid
  end

  it "is invalid without a last name" do
    FactoryGirl.build(:user, last_name: nil).should_not be_valid
  end

  it "is invalid without a username" do
    FactoryGirl.build(:user, username: nil).should_not be_valid
  end

  it "is invalid without an email address" do
    FactoryGirl.build(:user, email: nil).should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      FactoryGirl.build(:user, email: address).should be_valid
    end
  end

  it "is invalid with a duplicate email address" do
    FactoryGirl.create(:user, email: "test@example.com")
    FactoryGirl.build(:user, email: "TEST@example.com").should_not be_valid
  end

  describe "password validations" do
    it "invalid with short passwords" do
      short = "a" * 7
      user = FactoryGirl.build(:user, password: short, password_confirmation: short)
      user.should_not be_valid
    end

    it "is invalid with long passwords" do
      short = "a" * 41
      user = FactoryGirl.build(:user, password: short, password_confirmation: short)
      user.should_not be_valid
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe '#name' do
    before(:each) do
      @params = {
        first_name: "George",
        last_name: "Burdell"
      }
    end

    it "should concatenate first and last names" do
      user = FactoryGirl.build(:user, @params)
      user.name.should eq "George Burdell"
    end

    it "should prefer a display name if available" do
      @params.merge!(display_name: "George P. Burdell")
      user = FactoryGirl.build(:user, @params)
      user.name.should eq "George P. Burdell"
    end
  end

  describe "role associations" do
    pending "test user role"
  end
end
