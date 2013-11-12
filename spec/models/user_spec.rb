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
#  admin                  :boolean          default(FALSE)
#  buzzcard_id            :integer
#  buzzcard_facility_code :integer
#

require 'spec_helper'
require 'cancan/matchers'

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

  describe "abilities" do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context "when is an active staff member" do
      let(:user) { FactoryGirl.create(:user) }
      let(:user2) { FactoryGirl.create(:user) }

      # read
      it {
        should be_able_to(:read, Contest.new)
        should be_able_to(:read, ContestSuggestion.new)
        should be_able_to(:read, Venue.new)
        should be_able_to(:read, ListenerLog.new)
        should be_able_to(:read, ListenerTicket.new)
        should be_able_to(:read, PowerReading.new)
        should be_able_to(:read, Psa.new)
        should be_able_to(:read, PsaReading.new)
        should be_able_to(:read, Role.new)
        should be_able_to(:read, StaffTicket.new)
        should be_able_to(:read, TransmitterLogEntry.new)
        should be_able_to(:read, User.new)
        should be_able_to(:read, Venue.new)
      }

      # create
      it {
        should be_able_to(:create, ContestSuggestion.new)
        should be_able_to(:create, ListenerTicket.new)
        should be_able_to(:create, PsaReading.new)
        should be_able_to(:create, StaffTicket.new)
        should be_able_to(:create, TransmitterLogEntry.new)
      }

      # update
      it {
        should be_able_to(:update, TransmitterLogEntry.new(user_id: user.id))
        should_not be_able_to(:update, TransmitterLogEntry.new(user_id: user2.id))
      }

      # destroy
      it {
        should be_able_to(:destroy, ListenerTicket.new(user_id: user.id))
        should be_able_to(:destroy, StaffTicket.new(user_id: user.id))
        should_not be_able_to(:destroy, ListenerTicket.new(user_id: user2.id))
        should_not be_able_to(:destroy, StaffTicket.new(user_id: user2.id))
      }
    end

    context "when is a contest director" do
      let(:user) { FactoryGirl.create(:user, :contest_director) }

      # manage
      it {
        should be_able_to(:manage, Contest)
        should be_able_to(:manage, Venue)
        should be_able_to(:manage, StaffTicket)
        should be_able_to(:manage, ListenerTicket)
      }
    end

    context "when is a psa director" do
      let(:user) { FactoryGirl.create(:user, :psa_director) }

      # manage
      it {
        should be_able_to(:manage, Psa)
        should be_able_to(:manage, PsaReading)
      }
    end

    context "when is an admin" do
      let(:user) { FactoryGirl.create(:user, :admin) }

      # manage
      it {
        should be_able_to(:manage, Contest.new)
        should be_able_to(:manage, ContestSuggestion.new)
        should be_able_to(:manage, Venue.new)
        should be_able_to(:manage, ListenerLog.new)
        should be_able_to(:manage, ListenerTicket.new)
        should be_able_to(:manage, PowerReading.new)
        should be_able_to(:manage, Psa.new)
        should be_able_to(:manage, PsaReading.new)
        should be_able_to(:manage, Role.new)
        should be_able_to(:manage, StaffTicket.new)
        should be_able_to(:manage, TransmitterLogEntry.new)
        should be_able_to(:manage, User.new)
        should be_able_to(:manage, Venue.new)
      }
    end
  end
end
