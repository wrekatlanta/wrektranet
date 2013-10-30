# == Schema Information
#
# Table name: staff_tickets
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  contest_id          :integer
#  contest_director_id :integer
#  awarded             :boolean          default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#

class StaffTicket < ActiveRecord::Base
  after_save :update_counter_cache
  after_destroy :update_counter_cache

  belongs_to :user
  belongs_to :contest, -> { includes([:venue]) }, validate: true
  belongs_to :contest_director, class_name: "User"
  has_one :event, through: :contest

  default_scope -> { order('staff_tickets.created_at DESC') }
  scope :order_by_awarded, -> { order('awarded, staff_tickets.created_at DESC') }
  scope :awarded, -> { where(awarded: true) }
  scope :unawarded, -> { where(awarded: false) }
  scope :upcoming, -> {
    includes(contest: :event)
      .where("events.start_time >= :start_date", start_date: Time.zone.now.beginning_of_day)
  }
  scope :announceable, -> {
    includes(contest: :event)
      .where(contests: {sent: false})
      .where("contests.send_time > :start_date", start_date: Time.zone.now)
  }

  validates :contest_id, presence: :true
  validates :user_id, presence: :true
  validates_uniqueness_of :user_id, scope: [:contest_id]
  validate :ticket_count_within_limit, on: :update

  private
    def ticket_count_within_limit
      if self.awarded and self.contest.reload.staff_count >= self.contest.staff_ticket_limit
        errors.add(:base, "Too many staff tickets")
      end
    end

    def update_counter_cache
      self.contest.staff_count = self.contest.staff_tickets.awarded.count
      self.contest.save
    end
end
