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
  belongs_to :alternate_recipient, class_name: "Venue"
  has_many :staff_tickets, dependent: :destroy
  has_many :listener_tickets, dependent: :destroy
  has_many :users, through: :staff_tickets

  accepts_nested_attributes_for :staff_tickets, :listener_tickets, allow_destroy: true

  default_scope -> { order('date DESC') }
  scope :upcoming, -> { where("date >= :start_date", start_date: Time.zone.now.beginning_of_day) }
  scope :past, ->{ where("send_time < :start_date", start_date: Time.zone.now) }
  scope :unsent, -> { where(sent: false) }
  scope :announceable, ->{
    unsent.where(
      "send_time >= :start_date",
      start_date: Time.zone.now
    )
  }
  scope :without_user, -> (user) {
    where("id NOT IN (?)", user.contests) unless user.contests.blank?
  }

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

  def recipient
    return self.alternate_recipient || self.venue
  end

  private
    def set_default_values
      self.listener_ticket_limit ||= 0
      self.staff_ticket_limit ||= 0
      self.staff_count ||= 0
      self.listener_count ||= 0
    end
end
