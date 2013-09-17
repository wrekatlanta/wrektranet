# == Schema Information
#
# Table name: contests
#
#  id                     :integer          not null, primary key
#  venue_id               :integer
#  age_limit              :integer
#  pick_up                :boolean
#  listener_ticket_limit  :integer
#  staff_ticket_limit     :integer
#  notes                  :text
#  created_at             :datetime
#  updated_at             :datetime
#  listener_plus_one      :boolean          default(FALSE)
#  staff_plus_one         :boolean          default(FALSE)
#  send_time              :datetime
#  sent                   :boolean          default(FALSE)
#  staff_count            :integer
#  listener_count         :integer
#  alternate_recipient_id :integer
#

class Contest < ActiveRecord::Base
  after_initialize :set_default_values
  before_save :set_send_time

  belongs_to :venue
  belongs_to :alternate_recipient, class_name: "Venue"
  has_many :staff_tickets, dependent: :destroy
  has_many :listener_tickets, dependent: :destroy
  has_many :users, through: :staff_tickets

  accepts_nested_attributes_for :staff_tickets, :listener_tickets, allow_destroy: true

  default_scope -> { order('date DESC') }
  scope :upcoming, -> { where("date >= :start_date", start_date: Time.zone.now.beginning_of_day) }
  scope :past, -> { where("send_time < :start_date", start_date: Time.zone.now) }
  scope :sendable, -> (time) { where("send_time = :send_time", send_time: time) }
  scope :unsent, -> { where(sent: false) }
  scope :announceable, -> {
    unsent.where(
      "send_time >= :start_date",
      start_date: Time.zone.now
    )
  }
  scope :without_user, -> (user) {
    where("id NOT IN (?)", user.contests) unless user.contests.blank?
  }

  validates :venue, presence: true
  validates :age_limit, presence: true
  validates :listener_ticket_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :staff_ticket_limit, numericality: { greater_than_or_equal_to: 0 }
  validate :date_string_is_date

  def announceable?
    !self.sent and (self.send_time >= Time.zone.now.beginning_of_day)
  end

  def recipient
    return self.alternate_recipient || self.venue
  end

  def date_string
    @date_string || date.try(:strftime, "%-m/%-d/%y %-l:%M %p")
  end

  def date_string=(value)
    @date_string = value
    self.date = parse_date
  end

  def self.send_contests(hour = Time.zone.now.hour)
    time = Time.zone.now.beginning_of_day + hour.hours

    self.sendable(time).each do |contest|
      ContestMailer.ticket_email(contest).deliver
      contest.sent = true
      contest.save
    end
  end

  private
    def set_send_time
      self.send_time = self.date.beginning_of_day - self.venue.send_day_offset.days + self.venue.send_hour.hours
    end

    def set_default_values
      self.listener_ticket_limit ||= 0
      self.staff_ticket_limit ||= 0
      self.staff_count ||= 0
      self.listener_count ||= 0
    end

    def date_string_is_date
      errors.add(:date_string, "is invalid") unless parse_date
    end

    def parse_date
      Chronic.parse(date_string)
    end
end
