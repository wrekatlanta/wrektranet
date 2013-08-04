# == Schema Information
#
# Table name: contests
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  date              :datetime
#  venue_id          :integer
#  age_limit         :integer
#  pick_up           :boolean
#  listener_tickets  :integer
#  staff_tickets     :integer
#  notes             :text
#  created_at        :datetime
#  updated_at        :datetime
#  listener_plus_one :boolean
#  staff_plus_one    :boolean
#

class Contest < ActiveRecord::Base
  belongs_to :venue

  validates :name, presence: true
  validates :date, presence: true
  validates :age_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :listener_tickets, numericality: { greater_than_or_equal_to: 0 }
  validates :staff_tickets, numericality: { greater_than_or_equal_to: 0 }
end
