require 'spec_helper'

feature "Venue administration" do
  let(:user) { FactoryGirl.create(:user, :contest_director) }

  before do
    login_as user

    FactoryGirl.create_list(:venue, 4)
    visit admin_venues_path
  end

  scenario "Admin views venues" do
    expect(page).to have_selector('td', 3)
  end

  scenario "Admin creates a new venue", js: true do
    click_link "Add New"

    fill_in "Name", with: "Variety Playhouse"
    fill_in "Address", with: "1234 Candy Lane"
    select "17", from: "Send hour"
    select "1", from: "Send day offset"

    fill_in "newContactEmail", with: "test"
    expect(page).to have_css(".btn-primary[disabled]")

    fill_in "newContactEmail", with: "test@email.com"
    click_button "Add Contact"
    click_button "Remove Contact"

    fill_in "newContactEmail", with: "test1@email.com"
    click_button "Add Contact"

    fill_in "newContactEmail", with: "test2@email.com"
    click_button "Add Contact"

    click_button "Create Venue"

    venue = Venue.unscoped.last
    expect(venue.name).to eq "Variety Playhouse"
    expect(venue.contacts.count).to eq 2

    current_path.should == admin_venues_path
  end
end