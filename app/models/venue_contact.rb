# == Schema Information
#
# Table name: venue_contacts
#
#  venue_id   :integer
#  contact_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class VenueContact < ActiveRecord::Base
  belongs_to :venue
  belongs_to :contact
end
