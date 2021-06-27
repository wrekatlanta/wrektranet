require 'spec_helper'

feature "Venue administration" do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let!(:venues) { FactoryBot.create_list(:venue, 4) }

  before(:each) do
    login_with admin
    visit admin_venues_path
  end

  scenario "Admin views venues" do
    venues.each do |venue|
      expect(page).to have_content(venue.name)
      expect(page).to have_content(venue.address)
      venue.contacts.each do |contact|
        expect(page).to have_content(contact.email)
      end
    end
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

    number_of_contacts = 3

    number_of_contacts.times do |n|
      fill_in "newContactEmail", with: "test#{n}@email.com"
      click_button "Add Contact"
    end

    click_button "Create Venue"

    current_path.should == admin_venues_path
    expect(page).to have_content("Variety Playhouse created successfully.")
    expect(page).to_not have_content("test@email.com")
    number_of_contacts.times do |n|
      expect(page).to have_content("test#{n}@email.com")
    end
  end

  scenario "Admin removes contacts from venue", js: true do
    venue = FactoryBot.create(:venue, name: "Editable Venue")
    venue_name = venue.name

    removed_contacts = FactoryBot.create_list(:contact, 2, venue: venue)
    saved_contacts = FactoryBot.create_list(:contact, 2, venue: venue)

    visit edit_admin_venue_path(venue)

    removed_contacts.size.times do
      click_button "Remove Contact", match: :first
    end

    click_button "Update Venue"

    current_path.should == admin_venues_path
    expect(page).to have_content("#{venue_name} updated successfully.")

    removed_contacts.each do |contact|
      expect(page).to_not have_content contact.email
    end

    saved_contacts.each do |contact|
      expect(page).to have_content contact.email
    end
  end

  scenario "Admin deletes a venue", js: true do
    venue = FactoryBot.create(:venue)
    venue_name = venue.name

    visit edit_admin_venue_path(venue)

    click_link "Delete"
    current_path.should == admin_venues_path
    expect(page).to have_content(venue_name + " deleted successfully.")
  end
end