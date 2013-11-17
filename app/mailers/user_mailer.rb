class UserMailer < ActionMailer::Base
  default from: "it.director@wrek.org"

  def import_email(user, password, email)
    @user = user
    @password = password
    delivery_options = { user_name: ENV['GMAIL_IT_USERNAME'],
                         password: ENV['GMAIL_IT_PASSWORD'] }

    mail(to: email,
         subject: "[WREK] Your New Google Apps Account",
         delivery_method_options: delivery_options)
  end
end
