# == Schema Information
#
# Table name: program_log_schedules
#
#  id                   :integer          not null, primary key
#  program_log_entry_id :integer
#  start_date           :date
#  expiration_date      :date
#  start_time           :time
#  end_time             :time
#  repeat_interval      :integer          default(0)
#  sunday               :boolean          default(FALSE)
#  monday               :boolean          default(FALSE)
#  tuesday              :boolean          default(FALSE)
#  wednesday            :boolean          default(FALSE)
#  thursday             :boolean          default(FALSE)
#  friday               :boolean          default(FALSE)
#  saturday             :boolean          default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#

class ProgramLogSchedule < ActiveRecord::Base
  include NaturalLanguageDate

  before_save :normalize_attributes

  natural_language_date_attr :start_date, :date
  natural_language_date_attr :expiration_date, :date

  serialize :start_time, Tod::TimeOfDay
  serialize :end_time, Tod::TimeOfDay

  belongs_to :program_log_entry

  validate :program_log_entry, presence: true
  validate :start_date_string_is_date, unless: -> { self.start_date.blank? }
  validate :expiration_date_string_is_date, unless: -> { self.expiration_date.blank? }
  validate :expiration_date_in_future, unless: -> { self.expiration_date.blank? }
  validate :check_times

  # returns an array of the days of the week that a schedule occurs on
  def days
    result = []

    Date::DAYNAMES.each do |dayname|
      day = dayname.downcase.to_sym

      if self.send(day)
        result << day
      end
    end

    result
  end

  # we can't seem to make end_time be nil
  # since 00:00:00 is always before the start, treat that as nil
  def end_time
    original = read_attribute(:end_time)

    if original.to_s == '00:00:00'
      nil
    else
      original
    end
  end

  def normalize_attributes
    # end_time should not be an empty string for mysql; default to 00:00
    if self.end_time.blank?
      self.end_time = TimeOfDay.new(0, 0)
    end
  end

  # Finds schedules for a given day of the week (using Time#wday)
  def self.find_by_range(start_cutoff = Time.zone.now, end_cutoff = Time.zone.now)
    start_wday = Date::DAYNAMES[start_cutoff.wday].downcase
    end_wday = Date::DAYNAMES[end_cutoff.wday].downcase

    where(start_wday => true, end_wday => true).where(
      '(start_date IS NULL OR start_date <= ?) AND
      (expiration_date IS NULL OR expiration_date >= ?)',
      start_cutoff, start_cutoff
    )
  end

  private
    def expiration_date_in_future
      errors.add(:base, "Expiration dates cannot be in the past.") if
        !expiration_date.blank? and expiration_date < Time.zone.today

      errors.add(:base, "Expiration dates cannot be before start dates.") if
        !start_date.blank? and expiration_date < start_date
    end

    def check_times
      begin
        start_time_tod = TimeOfDay.parse(self.start_time)
        end_time_tod = TimeOfDay.parse(self.end_time) unless self.end_time.blank?
      rescue
        errors.add(:base, "You used an invalid time. Please use 24-hour or 12-hour formats.")
      end

      if end_time_tod and end_time_tod <= start_time_tod
        errors.add(:base, "End times must be after start times.")
      end
    end
end
