class Air::EventsController < Air::BaseController
  def index
    @classes = ['primary', 'success', 'info', 'warning', 'danger']
    @current_class = 0
    @class_assignments = {}

    @events = Rails.cache.fetch('events_calendar', expires_in: 1.hour) do
      events = []

      events += Contest.upcoming.up_to(2.weeks).map { |e| {
        name: e.name,
        date: e.start_time,
        location: e.venue.name,
        calendar: 'Contests',
        class: get_class('Contests')
      } }

      Calendar.find_each do |calendar|
        min_date = Time.zone.now
        max_date = min_date + calendar.weeks_to_show.weeks
        calendar_events = calendar.parse(min_date: min_date, max_date: max_date)

        calendar_events.map! { |e| {
          name: e.summary,
          date: e.dtstart,
          location: e.location.presence || calendar.default_location,
          calendar: calendar.name,
          class: get_class(calendar.name)
        } }

        events += calendar_events
      end

      events.sort_by { |event| event[:date] }
    end

    @event_days = @events.group_by { |e| e[:date].beginning_of_day }
  end

  private
    def get_class(calendar_name)
      if @class_assignments[calendar_name].blank?
        @class_assignments[calendar_name] = @classes[@current_class]
        @current_class = (@current_class + 1) % @classes.size
      end

      return @class_assignments[calendar_name]
    end
end