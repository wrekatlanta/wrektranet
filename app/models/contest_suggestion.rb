# == Schema Information
#
# Table name: contest_suggestions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  date       :datetime
#  venue      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ContestSuggestion < ActiveRecord::Base
  has_one :staff_ticket, as: :contest

  validates :name, presence: true
  validates :date, presence: true
  validates :venue, presence: true

  scope :unassigned, ->{
    joins("LEFT OUTER JOIN staff_tickets ON staff_tickets.contest_id = contest_suggestions.id").where("staff_tickets.contest_id IS null")
  }
end
