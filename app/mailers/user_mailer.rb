class UserMailer < Devise::Mailer

  layout 'email'

  def invitation_instructions(record, opts={})
    @user = record
    options = { delivery_method_options: {
                  user_name: ENV['GMAIL_BOT_USERNAME'],
                  password: ENV['GMAIL_BOT_PASSWORD']
                },
                subject: "[WREK] Wrektranet Account Created - Set Your Password"
              }


    devise_mail(record, :invitation_instructions, options)

  end

end