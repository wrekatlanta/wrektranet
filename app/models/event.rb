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
#  google_id      :string(255)
#

class Event < ActiveRecord::Base
  include NaturalLanguageDate

  after_create :add_to_calendar!

  belongs_to :eventable, polymorphic: true

  natural_language_date_attr :start_time
  natural_language_date_attr :end_time

  validates :name, presence: true
  validates :start_time, presence: true
  validate :start_time_string_is_date
  validate :end_time_string_is_date, unless: -> { self.end_time.blank? }

  def end_time_with_fallback(delta = 3.hours)
    self.end_time || (self.start_time ? self.start_time + 3.hours : nil)
  end

  def add_to_calendar!
    if Rails.env.production? and ENV.has_key?('EVENT_CALENDAR_ID') and self.public
      client = GoogleAppsHelper.create_client
      calendar = client.discovered_api('calendar', 'v3')
      result = client.execute(
        api_method: calendar.events.insert,
        parameters: { 'calendarId' => ENV['EVENT_CALENDAR_ID'] },
        body_object: {
          start: {
            dateTime: self.start_time.xmlschema
          },
          end: {
            dateTime: self.end_time_with_fallback.xmlschema
          },
          summary: self.name,
          location: self.try(:eventable).try(:venue).try(:name)
        }
      )

      self.google_id = result.data.id
      self.save!
    end
  end
end
