class VenueContact < ActiveRecord::Base
  belongs_to :venue
  belongs_to :contact
end
