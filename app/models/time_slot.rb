# == Schema Information
#
# Table name: time_slots
#
#  id         :integer          not null, primary key
#  start_time :time
#  end_time   :time
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  reason     :string(255)
#  date       :date
#

class TimeSlot < ActiveRecord::Base
  validates :date, :user_id, :start_time, :end_time, presence: true
  validates_uniqueness_of :user_id 
  validate :start_time_cannot_be_in_the_past, :end_time_cannot_be_before_start, :date_cannot_be_in_the_past
  scope :today, ->{ where("date > ? and (date < ? OR date is NULL)", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day) }
  belongs_to :user
  def start_time_cannot_be_in_the_past
      if start_time.present? && start_time < Time.now
          errors.add(:start_time, " can't be in the past")
      end
  end

  def date_cannot_be_in_the_past
      if date.present? && date < Date.today
          errors.add(:date, " can't be in the past")
      end
  end
  def end_time_cannot_be_before_start
      if end_time.present? && end_time <= start_time
          errors.add(:end_time, " can't be before start time.")
      end
  end
end
