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
  has_one :event, as: :eventable, dependent: :destroy

  accepts_nested_attributes_for :staff_tickets, :listener_tickets, allow_destroy: true
  accepts_nested_attributes_for :event

  default_scope -> { includes(:event).order('events.start_time DESC') }
  scope :upcoming, -> { where("events.start_time >= :start_time", start_time: Time.zone.now.beginning_of_day) }
  scope :past, -> { where("send_time < :start_time", start_time: Time.zone.now) }
  scope :sendable, -> (time) { where("send_time = :send_time", send_time: time) }
  scope :unsent, -> { where(sent: false) }
  scope :announceable, -> {
    unsent.where(
      "send_time >= :start_time",
      start_time: Time.zone.now
    )
  }
  scope :up_to, -> (time = 2.weeks) {
    where(
      "send_time <= :start_time",
      start_time: Time.zone.now.beginning_of_day + time
    )
  }
  scope :without_user, -> (user) {
    where("id NOT IN (?)", user.contests) unless user.contests.blank?
  }

  validates :venue, presence: true
  validates :age_limit, presence: true
  validates :listener_ticket_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :staff_ticket_limit, numericality: { greater_than_or_equal_to: 0 }

  def announceable?
    !self.sent and (self.send_time >= Time.zone.now.beginning_of_day)
  end

  def recipient
    return self.alternate_recipient || self.venue
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
      self.send_time = self.event.start_time.beginning_of_day - self.venue.send_day_offset.days + self.venue.send_hour.hours
    end

    def set_default_values
      self.listener_ticket_limit ||= 0
      self.staff_ticket_limit ||= 0
      self.staff_count ||= 0
      self.listener_count ||= 0
      self.staff_plus_one ||= true
      self.listener_plus_one ||= true
    end
end
