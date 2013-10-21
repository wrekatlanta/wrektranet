class UserMailer < ActionMailer::Base
  default from: "pstoic@wrek.org"

  def import_email(user, password, email)
    @user = user
    @password = password

    mail(to: email, subject: "[WREK] Your New Google Apps Account")
  end
end
