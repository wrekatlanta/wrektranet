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
#  send_time             :datetime
#  sent                  :boolean
#

class Contest < ActiveRecord::Base
  after_initialize :set_default_values
  before_save :set_send_time

  belongs_to :venue
  has_many :staff_tickets, dependent: :destroy
  has_many :listener_tickets, dependent: :destroy

  accepts_nested_attributes_for :staff_tickets, :listener_tickets, allow_destroy: true

  default_scope ->{ order('date DESC') }
  scope :upcoming, ->{ where("date >= :start_date", start_date: Time.zone.now.beginning_of_day) }
  scope :announceable, ->{
    where(
      "send_time >= :start_date",
      start_date: Time.zone.now.beginning_of_day
    ).where(sent: false)
  }
  scope :past, ->{ where("date < :start_date", start_date: Time.zone.now.beginning_of_day) }

  validate :staff_tickets_within_bounds
  validate :listener_tickets_within_bounds
  validates :name, presence: true
  validates :date, presence: true
  validates :venue, presence: true
  validates :age_limit, presence: true
  validates :listener_ticket_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :staff_ticket_limit, numericality: { greater_than_or_equal_to: 0 }

  def set_send_time
    self.send_time = self.date.beginning_of_day - self.venue.send_day_offset.days + self.venue.send_hour.hours
  end

  def announceable?
    !self.sent and (self.send_time >= Time.zone.now.beginning_of_day)
  end

  private
    def staff_tickets_within_bounds
      return if self.staff_tickets.blank?
      errors.add(:base, "Too many staff tickets") if self.staff_tickets.awarded.count > self.staff_ticket_limit
    end

    def listener_tickets_within_bounds
      return if self.listener_tickets.blank?
      errors.add(:base, "Too many listener tickets") if self.listener_tickets.length > self.listener_ticket_limit
    end

    def set_default_values
      self.listener_ticket_limit ||= 0
      self.staff_ticket_limit ||= 0
    end
end
