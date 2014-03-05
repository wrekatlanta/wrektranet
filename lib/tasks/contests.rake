task :send_contests, [:hour] => [:environment] do |t, args|
  args.with_defaults(hour: Time.zone.now.hour)

  time = Time.zone.now.beginning_of_day + args[:hour].hours

  contests = Contest.sendable(time)

  unless contests.empty?
    contests.each do |contest|
      ContestMailer.ticket_email(contest).deliver
      contest.sent = true
      contest.save
    end
  end
end