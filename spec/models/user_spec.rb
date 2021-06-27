# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  encrypted_password     :string(255)      default("")
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
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  middle_name            :string(255)
#  birthday               :date
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  exec_staff             :boolean          default(FALSE)
#  user_id                :integer
#  subscribed_to_staff    :boolean
#  subscribed_to_announce :boolean
#  facebook               :string(255)
#  spotify                :string(255)
#  lastfm                 :string(255)
#  points                 :integer          default(0)
#

require 'spec_helper'

describe User do
  it "has a valid factory" do
    FactoryBot.create(:user).should be_valid
  end

  it "is invalid without a first name" do
    FactoryBot.build(:user, first_name: nil).should_not be_valid
  end

  it "is invalid without a last name" do
    FactoryBot.build(:user, last_name: nil).should_not be_valid
  end

  it "is invalid without a username" do
    FactoryBot.build(:user, username: nil).should_not be_valid
  end

  it "is invalid without an email address" do
    FactoryBot.build(:user, email: nil).should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      FactoryBot.build(:user, email: address).should be_valid
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = FactoryBot.create(:user)
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
      FactoryBot.create(:user, first_name: "George", last_name: "Burdell")
    }

    its(:name) { should eq "George Burdell" }

    context "with a display name" do
      subject { 
        FactoryBot.create(:user,
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
