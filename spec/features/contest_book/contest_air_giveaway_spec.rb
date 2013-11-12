require 'spec_helper'

feature "Contest air giveaway" do
  let(:user) { FactoryGirl.create(:user) }
  let!(:send_hour) {
    if Time.zone.now == 23
      1
    else
      (Time.zone.now.beginning_of_hour + 1.hour).hour
    end
  }

  let!(:today) {
    if Time.zone.now.hour == 23
      return Time.zone.tomorrow.beginning_of_day
    else
      return Time.zone.today
    end
  }

  let!(:venue) { FactoryGirl.create(:venue, name: "Variety Playhouse", send_hour: send_hour) }
  let!(:early_venue) { FactoryGirl.create(:venue, :send_early, name: "The Masquerade", send_hour: send_hour) }

  let!(:sent_contest) { FactoryGirl.create(:contest, :sent, venue: venue) }

  let!(:announceable_contests) {
    [
      FactoryGirl.create(:contest, venue: venue, start_time: today + 1.day),
      FactoryGirl.create(:contest, venue: venue, start_time: today),
      FactoryGirl.create(:contest, venue: early_venue, start_time: today + 1.days)
    ]
  }

  let!(:unannounceable_contests) {
    [
      # sent contest
      FactoryGirl.create(:contest, :sent, venue: venue),
      # past contests
      FactoryGirl.create(:contest, venue: venue, start_time: today - 1.day),
      FactoryGirl.create(:contest, venue: early_venue, start_time: today),
      # over 2 weeks away
      FactoryGirl.create(:contest, venue: venue, start_time: today + 2.weeks),
      FactoryGirl.create(:contest, venue: early_venue, start_time: today + 2.weeks + 1.day)
    ]
  }

  before(:each) do
    login_with user
    visit air_contests_path
  end

  scenario "User views contests", js: true do
    expect(page).to have_selector('.panel', 2)

    announceable_contests.each do |contest|
      expect(page).to have_content(contest.name)
    end

    unannounceable_contests.each do |contest|
      expect(page).to_not have_content(contest.name)
    end
  end

  scenario "User views a contest" do
    contest = announceable_contests.first
    contest.update_attributes({
      listener_ticket_limit: 3,
      staff_ticket_limit: 2,
      age_limit: 21
    })

    click_link(contest.name)
    expect(page).to have_content(contest.name)
    expect(page).to have_content(contest.venue.name)
    expect(page).to have_content(contest.start_time.strftime("%A, %B %-d"))
    expect(page).to have_content(contest.start_time.strftime("%l:%M %p"))
    expect(page).to have_content("3 pairs")
    expect(page).to have_content("2 pairs")
    expect(page).to have_content("21+")
    expect(page).to have_content(contest.venue.address)
  end

  scenario "User adds and deletes listener ticket", js: true do
    name = Faker::Name.first_name
    phone = Faker::PhoneNumber.cell_phone

    contest = announceable_contests.first
    contest.update_attributes({
      listener_ticket_limit: 2
    })
    previous_ticket = FactoryGirl.create(:listener_ticket, contest: contest)

    click_link(contest.name)

    fill_in 'Name', with: name
    fill_in 'Phone', with: phone
    click_button 'Add Ticket'

    page.should_not have_selector(:link_or_button, 'Add Ticket')
    expect(page).to have_content(name)
    expect(page).to have_content(phone)

    click_button 'Delete Ticket'
    page.should_not have_selector(:link_or_button, 'Delete Ticket')
    expect(page).to have_content previous_ticket.name
    expect(page).to have_content previous_ticket.phone
  end

  scenario "User views a contest's staff tickets" do
    contest = announceable_contests.first
    contest.update_attributes({
      staff_ticket_limit: 2,
    })

    tickets = [FactoryGirl.create(:staff_ticket, contest: contest),
               FactoryGirl.create(:staff_ticket, :awarded, contest: contest)]

    click_link(contest.name)
    tickets.each { |ticket| expect(page).to have_content ticket.user.username }
    expect(page).to have_content 'Pending'
    expect(page).to have_content 'Received'
  end
end
