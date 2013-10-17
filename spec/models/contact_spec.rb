# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  venue_id   :integer
#

require 'spec_helper'

describe Contact do
  let(:venue) { FactoryGirl.create(:venue) }

  it "has a valid factory" do
    FactoryGirl.build(:contact).should be_valid
  end

  before do
    contact_attrs = {
      email: "gpb@wrek.org"
    }

    @contact = venue.contacts.new(contact_attrs)
  end

  subject { @contact }

  describe "#email" do
    context "not present" do
      before { @contact.email = nil }
      it { should_not be_valid }
    end
  end
end
