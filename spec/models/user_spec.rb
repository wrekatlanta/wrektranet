# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
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
#  admin                  :boolean          default(FALSE)
#  buzzcard_id            :integer
#  buzzcard_facility_code :integer
#  legacy_id              :integer
#  remember_token         :string(255)
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
    subject { 
      FactoryGirl.create(:user, first_name: "George", last_name: "Burdell")
    }

    its(:name) { should eq "George Burdell" }

    context "with a display name" do
      subject { 
        FactoryGirl.create(:user,
          first_name: "George",
          last_name: "Burdell",
          display_name: "George P. Burdell"
        )
      }

      its(:name) { should eq "George P. Burdell" }
    end
  end

  describe "role associations" do
    pending "test user role"
  end
end
