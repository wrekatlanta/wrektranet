task :send_contests, [:hour] => [:environment] do |t, args|
  args.with_defaults(hour: Time.zone.now.hour)

  time = Time.zone.now.beginning_of_day + args[:hour].hours

  contests = Contest.sendable(time)

  if contests.empty?
    puts "No sendable contests found."
  else
    contests.each do |contest|
      ContestMailer.ticket_email(contest).deliver
      contest.sent = true
      contest.save
    end
  end
end