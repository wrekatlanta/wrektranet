# NOT AN ACTIVERECORD MODEL
# A module that produces a hash for a week's show schedule.
module Legacy::Schedule
  SLOT_LENGTH = 10.minutes
  SLOT_PRIORITY = [:block, :specialty, :oto]

  def self.generate_for_day(time = Time.zone.now, opts = {})
    day = time.beginning_of_day
    channel = opts[:channel] || 'main'

    # query 'days' column by the first two letters, lowercase
    wday = Date::DAYNAMES[day.wday][0..1].downcase
    conditions = {
      channel: channel,
      days: wday
    }

    show_schedules = Legacy::ShowSchedule.where(
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

      if end_time == TimeOfDay.new(0, 0)
        end_time = TimeOfDay.new(23, 59, 59)
      end

      current_time = start_time

      while current_time < end_time
        schedule_bins[show.show_type.to_sym][current_time.to_s] = show

        if (current_time + SLOT_LENGTH) < current_time
          break
        else
          current_time += SLOT_LENGTH
        end
      end
    end

    result = {}

    SLOT_PRIORITY.each do |block_type|
      result.merge! schedule_bins[block_type]      
    end

    result = result.sort.map do |slot|
      {
        start_time: TimeOfDay.parse(slot[0]).on(day),
        show: slot[1],
        now_playing: false
      }
    end

    # add a current_show indicator by finding the current slot
    # and applying it to adjacent, previous instances of the show
    result.each_with_index do |slot, i|
      current_min = time.min - (time.min % SLOT_LENGTH)
      time_to_match = time.change(min: current_min)

      if slot[:start_time] == time_to_match
        slot[:now_playing] = true

        j = i - 1

        while (j >= 0)
          if result[j][:show] == slot[:show]
            result[j][:now_playing] = true
          else
            break
          end

          j -= 1
        end

        break
      end
    end

    result
  end
end