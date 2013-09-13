class ContestMailer < ActionMailer::Base
  layout 'email'
  default from: "contest.director@wrek.org"

  def ticket_email(contest)
    @contest = contest
    date = l(contest.date, format: :contest_date)

    mail(to: @contest.recipient.contacts.map(&:email), subject: "[WREK] Contest Winners for #{date}")
  end
end
