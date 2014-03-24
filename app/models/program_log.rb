# NOT AN ACTIVERECORD MODEL
# A container class that produces a hash of program log items.
class ProgramLog
  include IceCube

  def self.for_day(day = Time.zone.now, options = {})
    plog_schedules = ProgramLogSchedule
      .find_by_day(day)
      .includes(:program_log_entry)

    plog = {
      entries: {},
      occurrences: []
    }

    # calculate recurrences with ice_cube
    plog_schedules.find_each do |plog_schedule|
      start_time = plog_schedule.start_time.on(day)

      if plog_schedule.end_time
        end_time = plog_schedule.end_time.on(day)
      else
        end_time = start_time.end_of_day
      end

      schedule = Schedule.new(start_time)

      # use the repeat_interval to create a minutely rule
      if plog_schedule.repeat_interval > 0
        schedule.add_recurrence_rule(
          Rule.minutely(plog_schedule.repeat_interval)
        )
      else
        schedule.add_recurrence_rule(Rule.daily)
      end

      # convert markdown, etc. once per set of occurrences
      plog[:entries][plog_schedule.program_log_entry.id] ||= {
        title: plog_schedule.program_log_entry.title,
        description: ApplicationHelper.markdown(plog_schedule.program_log_entry.description)
      }

      # add occurrences to the program log
      # an occurrence is a hash with time, title, and markdown-converted description
      occurrences = schedule.occurrences(end_time)
      occurrences.map! do |occurrence|
        {
          time: occurrence,
          entry_id: plog_schedule.program_log_entry.id
        }
      end

      plog[:occurrences].concat occurrences
    end

    plog
  end
end