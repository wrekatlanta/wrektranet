# == Schema Information
#
# Table name: contests
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  date             :datetime
#  venue_id         :integer
#  age_limit        :integer
#  pick_up          :boolean
#  listener_tickets :integer
#  staff_tickets    :integer
#  notes            :text
#  created_at       :datetime
#  updated_at       :datetime
#

class Contest < ActiveRecord::Base
  belongs_to :venue
end
