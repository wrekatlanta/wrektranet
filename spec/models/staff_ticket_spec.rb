# == Schema Information
#
# Table name: staff_tickets
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  contest_id          :integer
#  contest_director_id :integer
#  awarded             :boolean          default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#  name                :string(255)
#

require 'spec_helper'

describe StaffTicket do
  let(:contest) { FactoryGirl.create(:contest) }
  let(:user) { FactoryGirl.create(:user) }

  it "has a valid factory" do
    FactoryGirl.create(:staff_ticket).should be_valid
  end

  before do
    staff_ticket_attrs = {
      contest: contest
    }

    @staff_ticket = user.staff_tickets.new(staff_ticket_attrs)
  end

  subject { @staff_ticket }

  describe "#awarded" do
    context "initialization" do
      its(:awarded) { should eq false }
    end
  end

  describe "awarded limit per contest" do
    before do
      @staff_ticket.awarded = false
      @staff_ticket.save
    end

    let(:contest) { FactoryGirl.create(:contest, staff_ticket_limit: 3) }

    context "where the limit has not been reached" do
      before do
        FactoryGirl.create_list(:staff_ticket, contest.staff_ticket_limit - 1,
          :awarded, contest: contest)
      end

      it "allows the new staff ticket to be approved" do
        @staff_ticket.awarded = true
        expect(@staff_ticket.save).to be_true
      end
    end

    context "where the limit has been reached" do
      before do
        FactoryGirl.create_list(:staff_ticket, contest.staff_ticket_limit,
          :awarded, contest: contest)
      end

      it "does not allow the new staff ticket to be approved" do
        @staff_ticket.awarded = true
        expect(@staff_ticket.save).to be_false
      end
    end
  end
end
