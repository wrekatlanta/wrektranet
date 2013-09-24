require 'spec_helper'

feature "Venue administration" do
  let(:user) { FactoryGirl.create(:user, :admin) }

  before(:each) do
    FactoryGirl.create_list(:venue, 4)

    login_with user
    visit admin_venues_path
  end

  scenario "Admin views venues" do
    expect(page).to have_selector('td', 3)
  end

  scenario "Admin creates a new venue", js: true do
    click_link "Add New"
    current_path.should == new_admin_venue_path

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

    expect(page).to have_content("Variety Playhouse created successfully.")

    current_path.should == admin_venues_path
  end

  scenario "Admin removes contacts from venue", js: true do
    venue = FactoryGirl.create(:venue, name: "Editable Venue")
    venue_name = venue.name
    FactoryGirl.create_list(:contact, 3, venue: venue)

    visit edit_admin_venue_path(venue)

    click_button "Remove Contact", match: :first
    click_button "Remove Contact", match: :first

    click_button "Update Venue"
    current_path.should == admin_venues_path
    expect(page).to have_content("#{venue_name} updated successfully.")

    visit edit_admin_venue_path(venue)
    expect(page).to have_css(".btn-danger", 1)
  end

  scenario "Admin deletes a venue", js: true do
    venue = FactoryGirl.create(:venue)
    venue_name = venue.name

    visit edit_admin_venue_path(venue)

    click_link "Delete"
    current_path.should == admin_venues_path
    expect(page).to have_content(venue_name + " deleted successfully.")
  end
end