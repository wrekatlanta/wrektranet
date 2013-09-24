require 'spec_helper'

feature "Contest administration" do
  let!(:venue) { FactoryGirl.create(:venue, name: "Variety Playhouse") }
  let!(:early_venue) { FactoryGirl.create(:venue, :send_early, name: "The Masquerade") }

  before do
    login_as FactoryGirl.create(:user, :admin)
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

    expect {
      click_button "Create Contest"
    }.to change { Contest.count }.by(1)

    current_path.should == admin_contests_path
  end

  scenario "Admin edits a contest" do
    contest = FactoryGirl.create(:contest)
    visit edit_admin_contest_path(contest)

    click_button "Update Contest"
    current_path.should == admin_contests_path
  end

  scenario "Admin deletes a contest" do
    contest = FactoryGirl.create(:contest)
    visit edit_admin_contest_path(contest)

    expect {
      click_link "Delete"
    }.to change { Contest.count }.by(-1)
  end
end

feature "Viewing contests" do
  let!(:venue) { FactoryGirl.create(:venue, name: "Variety Playhouse") }
  let!(:early_venue) { FactoryGirl.create(:venue, :send_early, name: "The Masquerade") }

  before do
    login_as FactoryGirl.create(:user, :admin)
    visit admin_contests_path

    today = Time.zone.today.beginning_of_day

    # upcoming scope
    FactoryGirl.create(:contest, venue: venue,
      event: FactoryGirl.create(:event, start_time: today + 1.day))
    FactoryGirl.create(:contest, venue: venue,
      event: FactoryGirl.create(:event, start_time: today))
    FactoryGirl.create(:contest, venue: early_venue,
      event: FactoryGirl.create(:event, start_time: today + 1.day))

    # past scope
    FactoryGirl.create(:contest, :sent, venue: venue,
      event: FactoryGirl.create(:event, start_time: today - 1.day))
    FactoryGirl.create(:contest, :sent, venue: early_venue,
      event: FactoryGirl.create(:event, start_time: today))
  end

  scenario "Admin views upcoming contests" do
    click_link "Upcoming"
    current_path.should == admin_contests_path

    expect(page).to have_selector('td', 3)
    expect(page).to have_selector('.label-success', 9)
  end

  scenario "Admin views past contests" do
    click_link "Past"
    current_path.should == past_admin_contests_path

    expect(page).to have_selector('td', 2)
    expect(page).to have_selector('.label-success', 4)
    expect(page).to have_selector('.label-danger', 2)
  end
end