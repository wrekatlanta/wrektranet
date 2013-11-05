class UserMailer < ActionMailer::Base
  after_filter :set_delivery_options

  def import_email(user, password, email)
    @user = user
    @password = password

    mail(to: email, subject: "[WREK] Your New Google Apps Account")
  end

  private
    def set_delivery_options
      delivery_options = { user_name: ENV['GMAIL_IT_USERNAME'],
                           password: ENV['GMAIL_IT_PASSWORD'] }
      mail.delivery_method.settings.merge!(delivery_options)
    end
end
