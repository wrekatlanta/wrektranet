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
      FactoryGirl.create(:contest, venue: venue,
        event: FactoryGirl.create(:event, start_time: today + 1.day)),
      FactoryGirl.create(:contest, venue: venue,
        event: FactoryGirl.create(:event, start_time: today)),
      FactoryGirl.create(:contest, venue: early_venue,
        event: FactoryGirl.create(:event, start_time: today + 1.days))
    ]
  }

  let!(:unannounceable_contests) {
    [
      # sent contest
      FactoryGirl.create(:contest, :sent, venue: venue),
      # past contests
      FactoryGirl.create(:contest, venue: venue,
        event: FactoryGirl.create(:event, start_time: today - 1.day)),
      FactoryGirl.create(:contest, venue: early_venue,
        event: FactoryGirl.create(:event, start_time: today)),
      # over 2 weeks away
      FactoryGirl.create(:contest, venue: venue,
        event: FactoryGirl.create(:event, start_time: today + 2.weeks)),
      FactoryGirl.create(:contest, venue: early_venue,
        event: FactoryGirl.create(:event, start_time: today + 2.weeks + 1.day))
    ]
  }

  before(:each) do
    login_with user
    visit air_contests_path
  end

  scenario "User views contests" do
    expect(page).to have_selector('.panel', 2)

    announceable_contests.each do |contest|
      expect(page).to have_content(contest.event.name)
    end

    unannounceable_contests.each do |contest|
      expect(page).to_not have_content(contest.event.name)
    end
  end

  scenario "User views a contest" do
    
  end

  scenario "User adds listener tickets" do

  end

  scenario "User deletes a listener ticket" do

  end
end
