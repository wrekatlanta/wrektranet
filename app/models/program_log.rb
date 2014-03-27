# NOT AN ACTIVERECORD MODEL
# A module that produces a hash of program log items.
module ProgramLog
  DEFAULT_LIMIT = 2.hours

  def self.generate(time = Time.zone.now, opts = {})
    opts[:limit] ||= DEFAULT_LIMIT

    day = time.beginning_of_day
    start_cutoff = time.beginning_of_hour
    end_cutoff = (start_cutoff + opts[:limit]) - 1.second
    # bring the end_cutoff 1 second to hide the next hour

    plog_schedules = ProgramLogSchedule
      .find_by_range(start_cutoff, end_cutoff)
      .includes(:program_log_entry)

    plog = {
      entries: {},
      occurrences: []
    }

    # calculate recurrences with ice_cube
    plog_schedules.find_each do |plog_schedule|
      start_time = plog_schedule.start_time.on(day)

      unless plog_schedule.end_time.blank?
        end_time = plog_schedule.end_time.on(day)
      else
        end_time = end_cutoff
      end

      schedule = IceCube::Schedule.new start_time

      # add rules for days of the week, in case we go into the next day
      schedule.add_recurrence_rule(
        IceCube::Rule.weekly(1).day(*plog_schedule.days)
      )

      # use the repeat_interval to create a minutely rule
      # also add the end_time, defaulting to the end cutoff
      if plog_schedule.repeat_interval > 0
        schedule.add_recurrence_rule(
          IceCube::Rule.minutely(plog_schedule.repeat_interval).until(end_time)
        )
      end

      # convert markdown, etc. once per set of occurrences
      plog[:entries][plog_schedule.program_log_entry.id] ||= {
        title: plog_schedule.program_log_entry.title,
        description: ApplicationHelper.markdown(
          plog_schedule.program_log_entry.description
        )
      }

      # add occurrences to the program log
      # an occurrence is a hash with time, title, and markdown-converted description
      occurrences = schedule.occurrences_between(start_cutoff, end_cutoff)
      occurrences.map! do |occurrence|
        {
          time: occurrence,
          entry_id: plog_schedule.program_log_entry.id
        }
      end

      plog[:occurrences].concat occurrences
    end

    plog[:occurrences].sort_by! { |o| o[:time] }

    plog
  end
end