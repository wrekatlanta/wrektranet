require 'spec_helper'

feature "Staff ticket signup" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:awarded_staff_tickets) { FactoryGirl.create_list(:staff_ticket, 2, :awarded) }
  let!(:pending_staff_tickets) { FactoryGirl.create_list(:staff_ticket, 2) }
  let!(:user_staff_tickets) { FactoryGirl.create_list(:staff_ticket, 2, user: user) }

  before(:each) do
    login_with user
    visit staff_tickets_path
  end

  scenario "User views everyone's signups" do
    expect(page).to have_selector('tr', 6)
    expect(page).to have_selector('.label-default', 4)
    expect(page).to have_selector('.label-success', 2)
    expect(page).to have_selector('.btn-danger', 2)

    tickets = awarded_staff_tickets
                .concat(pending_staff_tickets)
                .concat(user_staff_tickets)

    tickets.each do |ticket|
      expect(page).to have_content ticket.user.username
      expect(page).to have_content ticket.contest.name
      expect(page).to have_content ticket.contest.start_time.strftime("%-m/%-d/%y %-l:%M %p")
      expect(page).to have_content ticket.created_at.strftime("%-m/%-d/%y %-l:%M %p")
      expect(page).to have_content ticket.contest.venue.name
    end
  end

  scenario "Users views own signups" do
    expect(page).to have_selector('tr', 2)
    expect(page).to have_selector('.label-default', 2)
    expect(page).to have_selector('.btn-danger', 2)
  end
end