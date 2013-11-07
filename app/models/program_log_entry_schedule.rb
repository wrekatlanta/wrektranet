# == Schema Information
#
# Table name: program_log_entry_schedules
#
#  id                   :integer          not null, primary key
#  program_log_entry_id :integer
#  start_date           :date
#  expiration_date      :date
#  start_time           :time
#  end_time             :time
#  repeat_interval      :integer
#  sunday               :boolean
#  monday               :boolean
#  tuesday              :boolean
#  wednesday            :boolean
#  thursday             :boolean
#  friday               :boolean
#  saturday             :boolean
#  created_at           :datetime
#  updated_at           :datetime
#

class ProgramLogEntrySchedule < ActiveRecord::Base
  serialize :start_time, Tod::TimeOfDay
  serialize :end_time, Tod::TimeOfDay

  belongs_to :program_log_entry

  validate :start_date_string_is_date, unless: -> { self.start_date.blank? }
  validate :expiration_date_string_is_date, unless: -> { self.expiration_date.blank? }
  validate :expiration_date_in_future, on: :save, unless: -> { self.expiration_date.blank? }

  def start_date_string
    @start_date_string || self.try(:start_date).try(:strftime, "%-m/%-d/%y")
  end

  def start_date_string=(value)
    @start_date_string = value
    self.start_date = parse_date(value)
  end

  def expiration_date_string
    @expiration_date_string || self.try(:expiration_date).try(:strftime, "%-m/%-d/%y")
  end

  def expiration_date_string=(value)
    @expiration_date_string = value
    self.expiration_date = parse_date(value)
  end

  private
    def expiration_date_in_future
      errors.add(:expiration_date, "Cannot be in the past.") if
        !expiration_date.blank? and expiration_date < Time.zone.today
    end

    def expiration_date_string_is_date
      errors.add(:expiration_date_string, "is invalid") unless parse_date(expiration_date_string)
    end

    def parse_date(chronic_string)
      Chronic.parse(chronic_string)
    end
end
