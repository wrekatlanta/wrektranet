require 'spec_helper'

feature "Contest administration" do
  let!(:venue) { FactoryBot.create(:venue, name: "Variety Playhouse") }
  let!(:early_venue) { FactoryBot.create(:venue, :send_early, name: "The Masquerade") }
  let!(:today) { Time.zone.today.beginning_of_day }

  let!(:upcoming_contests) {
    [
      FactoryBot.create(:contest, venue: venue, start_time: today + 1.day),
      FactoryBot.create(:contest, venue: venue, start_time: today),
      FactoryBot.create(:contest, venue: early_venue, start_time: today + 1.day)
    ]
  }

  let!(:past_contests) {
    [
      FactoryBot.create(:contest, :sent, venue: venue, start_time: today - 1.day),
      FactoryBot.create(:contest, :sent, venue: early_venue, start_time: today)
    ]
  }

  before do
    user = FactoryBot.create(:user, :admin)
    login_with user
    visit admin_contests_path
  end

  scenario "Admin creates a new contest" do
    click_link "Add New"

    fill_in "Name", with: "George and the Burdells"
    fill_in "Start time", with: "next Tuesday at 7:00pm"
    check "Public"

    select "Variety Playhouse", from: "Venue"
    select "The Masquerade", from: "Alternate recipient"

    select "18+", from: "Age limit"

    fill_in "contest[listener_ticket_limit]", with: 5
    check "contest[listener_plus_one]"

    fill_in "contest[staff_ticket_limit]", with: 3
    check "contest[staff_plus_one]"

    click_button "Create Contest"
    current_path.should == new_admin_contest_path
    expect(page).to have_content("George and the Burdells created successfully.")
  end

  scenario "Admin edits a contest" do
    contest = FactoryBot.create(:contest)
    visit edit_admin_contest_path(contest)

    click_button "Update Contest"
    current_path.should == admin_contests_path
    expect(page).to have_content("#{contest.name} updated successfully.")
  end

  scenario "Admin deletes a contest" do
    contest = FactoryBot.create(:contest)
    visit edit_admin_contest_path(contest)

    click_link "Delete"
    current_path.should == admin_contests_path
    expect(page).to have_content("#{contest.name} deleted successfully.")
  end

  scenario "Admin views upcoming contests" do
    click_link "Upcoming"
    current_path.should == admin_contests_path

    upcoming_contests.each do |contest|
      expect(page).to have_content contest.name
    end

    expect(page).to have_selector('.label-success', 9)
  end

  scenario "Admin views past contests" do
    click_link "Past"
    current_url.should == admin_contests_url(:filter => 'past')

    past_contests.each do |contest|
      expect(page).to have_content contest.name
    end
    expect(page).to have_selector('.label-success', 4)
    expect(page).to have_selector('.label-danger', 2)
  end
end