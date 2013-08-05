# == Schema Information
#
# Table name: staff_tickets
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  contest_id          :integer
#  contest_director_id :integer
#  awarded             :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe StaffTicket do

  it "has a valid factory" do
    FactoryGirl.create(:staff_ticket).should be_valid
  end

  describe "#award" do
    subject { FactoryGirl.create(:staff_ticket) }

    let(:contest_director) { FactoryGirl.create(:contest_director) }

    before do
      subject.award(contest_director)
    end

    its(:awarded) { should be_true }
    its(:contest_director) { should eq contest_director }
  end

  describe ".create_from_suggestion" do
    let(:suggestion) { FactoryGirl.create(:contest_suggestion) }
    let(:contest) { FactoryGirl.create(:contest) }
    subject { StaffTicket.create_from_suggestion!(suggestion, contest) }

    before { subject.save }
    
    it "should create a new staff ticket" do
      subject.should be_a_kind_of(StaffTicket)
    end

    it "should archive the suggestion" do
      suggestion.archived.should eq true
    end

    its(:user) { should eq suggestion.user }
    its(:contest) { should eq contest }
    its(:created_at) { should eq suggestion.created_at }
  end
end
