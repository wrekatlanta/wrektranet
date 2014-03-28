# Parses Google Calendar iCalendar feeds into a hash
module CalendarParser
  require 'icalendar'
  require 'open-uri'

  def self.parse(calendar_url, options = {})
    calendar = nil
    events = nil

    open(calendar_url) do |cal|
      calendar = Icalendar.parse(cal)[0]
    end

    if options[:min_date] and options[:max_date]
      events = calendar.
        events.select! { |event|
          event.dtstart >= options[:min_date] and
            event.dtstart <= options[:max_date]
        }
    elsif options[:min_date]
      events = calendar.
        events.select! { |event|
          event.dtstart >= options[:min_date]
        }
    elsif options[:max_date]
      events = calendar.
        events.select! { |event|
          event.dtstart <= options[:max_date]
        }
    else
      events = calendar.events
    end

    return events.sort_by { |event| event.dtstart }
  end
end