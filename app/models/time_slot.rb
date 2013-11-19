# == Schema Information
#
# Table name: time_slots
#
#  id         :integer          not null, primary key
#  start_time :datetime
#  end_time   :datetime
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  reason     :string(255)
#

class TimeSlot < ActiveRecord::Base
  validates :user_id, :start_time, :end_time, presence: true
  validates_uniqueness_of :user_id 
  validate :start_time_cannot_be_in_the_past, :end_time_cannot_be_before_start

  def start_time_cannot_be_in_the_past
      if start_time.present? && start_time < Date.today
          errors.add(:start_time, " can't be in the past")
      end
  end

  def end_time_cannot_be_before_start
      if end_time.present? && end_time <= start_time
          errors.add(:end_time, " can't be before start time.")
      end
  end
end
