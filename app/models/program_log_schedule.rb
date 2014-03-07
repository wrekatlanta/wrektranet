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

class ProgramLogSchedule < ActiveRecord::Base
  include NaturalLanguageDate
  require 'tod'

  natural_language_date_attr :start_date, :date
  natural_language_date_attr :expiration_date, :date

  serialize :start_time, Tod::TimeOfDay
  serialize :end_time, Tod::TimeOfDay

  belongs_to :program_log_entry

  validate :program_log_entry, presence: true
  validate :start_date_string_is_date, unless: -> { self.start_date.blank? }
  validate :expiration_date_string_is_date, unless: -> { self.expiration_date.blank? }
  validate :expiration_date_in_future, on: :save, unless: -> { self.expiration_date.blank? }
  validate :check_times

  # we can't seem to make end_time be null
  # since 00:00:00 is always before the start, treat that as nil
  def end_time
    original = read_attribute(:end_time)

    if original.to_s == '00:00:00'
      nil
    else
      original
    end
  end

  # Finds schedules for a given day of the week (using Time#wday)
  def self.find_by_wday(wday = nil)
    wday_mapping = ['sunday', 'monday', 'tuesday', 'wednesday',
                    'thursday', 'friday', 'saturday']

    wday ||= Time.zone.now.wday
    day = wday_mapping[wday] || wday_mapping[0]

    where(day => true)
  end

  private
    def expiration_date_in_future
      errors.add(:expiration_date, "cannot be in the past.") if
        !expiration_date.blank? and expiration_date < Time.zone.today
    end

    def check_times
      begin
        start_time = TimeOfDay.parse(self.start_time)
        end_time = TimeOfDay.parse(self.end_time) unless self.end_time.blank?
      rescue
        errors.add(:base, "You used an invalid time. Please use 24-hour or 12-hour formats.")
      end

      if end_time and end_time <= start_time
        errors.add(:base, "End times must be after start times.")
      end
    end
end
