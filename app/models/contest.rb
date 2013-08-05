# == Schema Information
#
# Table name: contests
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  date                  :datetime
#  venue_id              :integer
#  age_limit             :integer
#  pick_up               :boolean
#  listener_ticket_limit :integer
#  staff_ticket_limit    :integer
#  notes                 :text
#  created_at            :datetime
#  updated_at            :datetime
#  listener_plus_one     :boolean
#  staff_plus_one        :boolean
#

class Contest < ActiveRecord::Base
  belongs_to :venue
  has_many :staff_tickets
  has_many :listener_tickets

  validate :staff_tickets_within_bounds
  validate :listener_tickets_within_bounds

  validates :name, presence: true
  validates :date, presence: true
  validates :age_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :listener_ticket_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :staff_ticket_limit, numericality: { greater_than_or_equal_to: 0 }

  private
  def staff_tickets_within_bounds
    return if self.staff_tickets.blank?
    errors.add(:base, "Too many staff tickets") if self.staff_tickets.count > self.staff_ticket_limit
  end

  def listener_tickets_within_bounds
    return if self.listener_tickets.blank?
    errors.add(:base, "Too many listener tickets") if self.listener_tickets.length > self.listener_ticket_limit
  end
end
