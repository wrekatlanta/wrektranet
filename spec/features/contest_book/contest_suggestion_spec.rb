require 'spec_helper'

feature "Contest suggestion" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:contest_suggestions) { FactoryGirl.create_list(:contest_suggestion, 5) }
  let!(:past_suggestion) { FactoryGirl.create(:contest_suggestion, date: Time.zone.now - 1.day)}

  before(:each) do
    login_with user
    visit staff_contest_suggestions_path
  end

  scenario "User views contest suggestions" do
    contest_suggestions.each do |suggestion|
      expect(page).to have_content suggestion.user.username
      expect(page).to have_content suggestion.name
      expect(page).to have_content suggestion.date.strftime("%-m/%-d/%Y")
      expect(page).to have_content suggestion.created_at.strftime("%-m/%-d/%y %-l:%M %p")
    end

    expect(page).to_not have_content past_suggestion.name
  end

  scenario "User creates a contest suggestion" do
    click_link("Add New")

    fill_in "Name", with: "Event Name"
    fill_in "Date", with: "next week"
    fill_in "Venue", with: "Venue Name"
    click_button "Create Contest suggestion"

    expect(page).to have_content "Your suggestion has been added."
  end
end