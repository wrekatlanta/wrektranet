# == Schema Information
#
# Table name: listener_tickets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  phone      :string(255)
#  contest_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ListenerTicket do
  let(:contest) { FactoryBot.create(:contest) }
  let(:user) { FactoryBot.create(:user) }

  it "has a valid factory" do
    FactoryBot.create(:listener_ticket).should be_valid
  end

  before do
    listener_ticket_attrs = {
      name: "George Burdell",
      phone: "404-894-2468",
      user: user
    }

    @listener_ticket = contest.listener_tickets.new(listener_ticket_attrs)
  end

  subject { @listener_ticket }

  describe "limit per contest" do
    let(:contest) { FactoryBot.create(:contest, listener_ticket_limit: 3) }

    context "where the limit has not been reached" do
      before do
        FactoryBot.create_list(:listener_ticket, contest.listener_ticket_limit - 1,
          contest: contest)
      end

      it "allows the new listener ticket to be saved" do
        expect(@listener_ticket.save).to be_true
      end
    end

    context "where the limit has been reached" do
      before do
        FactoryBot.create_list(:listener_ticket, contest.listener_ticket_limit,
          contest: contest)
      end

      it "does not allow the new listener ticket to be approved" do
        expect(@listener_ticket.save).to be_false
      end
    end
  end
end
