# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  eventable_id   :integer
#  eventable_type :string(255)
#  name           :string(255)
#  start_time     :datetime
#  end_time       :datetime
#  all_day        :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  public         :boolean          default(TRUE)
#

class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true

  validates :name, presence: true
  validates :start_time, presence: true
  validate :start_time_string_is_date
  validate :end_time_string_is_date, unless: -> { self.end_time.blank? }

  def start_time_string
    @start_time_string || self.try(:start_time).try(:strftime, "%-m/%-d/%y %-l:%M %p")
  end

  def start_time_string=(value)
    @start_time_string = value
    self.start_time = parse_date(value)
  end

  def end_time_string
    @end_time_string || end_time.try(:strftime, "%-m/%-d/%y %-l:%M %p")
  end

  def end_time_string=(value)
    @end_time_string = value
    self.end_time = parse_date(value)
  end

  private
    def start_time_string_is_date
      errors.add(:start_time_string, "is invalid") unless parse_date(start_time_string)
    end

    def end_time_string_is_date
      errors.add(:end_time_string, "is invalid") unless parse_date(end_time_string)
    end

    def parse_date(chronic_string)
      Chronic.parse(chronic_string)
    end
end
