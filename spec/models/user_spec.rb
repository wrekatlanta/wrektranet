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
  before(:each) do
    @attr = {
      first_name:            "George",
      last_name:             "Burdell",
      username:              "gpb",
      email:                 "user@example.com",
      password:              "password",
      password_confirmation: "password"
    }
  end

  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  it "should require a first name" do
    no_first_name_user = User.new(@attr.merge(first_name: ""))
    no_first_name_user.should_not be_valid
  end

  it "should require a last name" do
    no_last_name_user = User.new(@attr.merge(last_name: ""))
    no_last_name_user.should_not be_valid
  end

  it "should require a username" do
    no_username_user = User.new(@attr.merge(username: ""))
    no_username_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(email: ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(email: address))
      valid_email_user.should be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge!(email: upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do
    it "should reject short passwords" do
      short = "a" * 7
      hash = @attr.merge(password: short, password_confirmation: short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(password: long, password_confirmation: long)
      User.new(hash).should_not be_valid
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
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
    it "should concatenate first and last names" do
      User.new(@attr).name.should eq "George Burdell"
    end

    it "should prefer a display name if available" do
      hash = @attr.merge(display_name: "George P. Burdell")
      User.new(hash).name.should eq "George P. Burdell"
    end
  end

  describe "role associations" do
    pending "test user role"
  end
end
