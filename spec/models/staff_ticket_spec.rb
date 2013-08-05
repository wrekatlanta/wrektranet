# == Schema Information
#
# Table name: staff_tickets
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  contest_id          :integer
#  contest_type        :string(255)
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

    let(:contest_director) {
      FactoryGirl.create(:contest_director)
    }

    before do
      subject.award(contest_director)
    end

    its(:awarded) { should be_true }
    its(:contest_director) { should eq contest_director }
  end
end
