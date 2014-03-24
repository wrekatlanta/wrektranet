# NOT AN ACTIVERECORD MODEL
# A container class that produces a hash for a week's show schedule.
class Legacy::Schedule
  require 'tod'

  SLOT_LENGTH = 30.minutes

  def self.for_day(day = Time.zone.now, options = {})
    channel = options[:channel] || 'main'

    # query 'days' column by the first two letters, lowercase
    wday = Date::DAYNAMES[day.wday][0..1].downcase
    conditions = {
      channel: channel,
      days: wday
    }

    show_schedules = ShowSchedule.where(
      'channel = ? AND days = ? AND start_date <= ? AND end_date >= ?',
      channel, wday, day, day
    ).includes(:show)

    schedule_bins = {
      block: {},
      specialty: {},
      oto: {}
    }

    show_schedules.each do |schedule|
      if schedule.show.nil?
        continue
      end

      show = schedule.show

      start_time = schedule.start_time.to_time_of_day
      end_time = schedule.end_time.to_time_of_day

      current_time = start_time

      while current_time != end_time
        schedule_bins[show.show_type.to_sym][current_time.to_s] = show

        current_time += SLOT_LENGTH
      end
    end

    result = {}

    result.merge! schedule_bins[:block]
    result.merge! schedule_bins[:specialty]
    result.merge! schedule_bins[:oto]

    result.sort.map do |x|
      return {
        start_time: x[0],
        end_time: x[0] + SLOT_LENGTH - 1.second,
        show: x[1]
      }
    end
  end
end