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
#  name                   :string(255)
#  start_time             :datetime
#  public_wrek            :boolean          default(TRUE)
#

class Contest < ActiveRecord::Base
  include NaturalLanguageDate

  after_initialize :set_default_values
  before_save :update_send_time

  belongs_to :venue
  belongs_to :alternate_recipient, class_name: "Venue"
  has_many :staff_tickets, dependent: :destroy
  has_many :listener_tickets, dependent: :destroy
  has_many :users, through: :staff_tickets

  accepts_nested_attributes_for :staff_tickets, :listener_tickets, allow_destroy: true

  natural_language_date_attr :start_time
  natural_language_date_attr :end_time

  validates :name, presence: true
  validates :start_time, presence: true
  validate :start_time_string_is_date
  validates :venue, presence: true
  validates :age_limit, presence: true
  validates :listener_ticket_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :staff_ticket_limit, numericality: { greater_than_or_equal_to: 0 }

  default_scope -> { order('send_time ASC') }

  scope :public_wrek, -> { where(public_wrek: true) }

  scope :upcoming, -> {
    today = Time.zone.now.beginning_of_day

    where("start_time >= :cutoff_date", cutoff_date: today)
      .reorder('start_time ASC')
  }

  scope :past, -> {
    where("send_time < :start_time", start_time: Time.zone.now)
      .reorder('send_time DESC')
  }

  scope :sendable, -> (time) {
    # matches send time and makes sure there are listener tickets if listener tickets are allowed
    # if there are no listener tickets allowed, check if there are staff counts
    where("send_time = :send_time and
      (listener_count > 0 or (listener_ticket_limit = 0 and staff_count > 0))",
      send_time: time)
  }

  scope :unsent, -> { where(sent: false) }

  scope :announceable, -> {
    unsent.where("send_time >= :cutoff_time", cutoff_time: Time.zone.now)
  }

  scope :up_to, -> (time = 2.weeks) {
    cutoff = Time.zone.now.beginning_of_day + time
    where("send_time <= :cutoff_date", cutoff_date: cutoff)
  }

  scope :without_user, -> (user) {
    # FIXME: replace array with subquery once Rails 4.1/figaro bug is fixed
    where("id NOT IN (?)", user.contests.to_a) unless user.contests.blank?
  }

  def announceable?(time = 2.weeks)
    today = Time.zone.now.beginning_of_day
    !self.sent and (self.send_time >= today) and (self.send_time <= (today + time))
  end

  def recipient
    return self.alternate_recipient || self.venue
  end

  def venue_and_alternate
    name = self.venue.name
    if self.alternate_recipient
      name += " (via #{self.alternate_recipient.name})"
    end

    return name
  end

  def update_send_time
    self.send_time = self.start_time.beginning_of_day -
                     self.recipient.send_day_offset.days +
                     self.recipient.send_hour.hours
  end

  def end_time
    self.start_time.tomorrow.beginning_of_day
  end

  private
    def set_default_values
      self.listener_ticket_limit ||= 0
      self.staff_ticket_limit ||= 0
      self.staff_count ||= 0
      self.listener_count ||= 0

      unless self.persisted?
        self.staff_plus_one = true
        self.listener_plus_one = true
      end
    end
end
