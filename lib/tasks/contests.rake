task :send_contests => [:environment], :hour do |t, args|
  args.with_defaults(hour: Time.zone.now.hour)

  time = Time.zone.now.beginning_of_day + hour.hours

  Contest.sendable(time).each do |contest|
    ContestMailer.ticket_email(contest).deliver
    contest.sent = true
    contest.save
  end
end