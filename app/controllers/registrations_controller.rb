class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)

    current_password = params[:user][:current_password]
    new_password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]

    # in production, don't use update_with_password because of ldap
    # this is a messy solution for handling password updates and whatnot
    if Rails.env.production?
      passwords_match = @user.legacy_profile.password == Legacy::Staff.legacy_password_hash(current_password)

      if passwords_match
        if not new_password.blank?
          # do we have a new password?
          if new_password == password_confirmation
            # new passwords match, update the user
            user_updated = @user.update_attributes(account_update_params)

            # update ldap and legacy_profile with the new password
            password = new_password
          else
            flash[:danger] = "Your new passwords didn't match."
          end
        else
          # no new password
          user_updated = @user.update_attributes(account_update_params)

          # update ldap and legacy_profile with current_password
          password = current_password
        end
      else
        flash[:danger] = "Your current password didn't match."
      end

      user_updated ||= false
    else
      # in development, just use update_with_password
      user_updated = @user.update_with_password(account_update_params)

      password = new_password || current_password
    end

    if user_updated and @user.sync_to_legacy_profile!(password) and @user.sync_to_ldap(password)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, bypass: true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  private
    def account_update_params
      permitted = [
        :email, :subscribed_to_announce, :subscribed_to_staff, :mark_as_inactive,
        :first_name, :middle_name, :last_name, :display_name, :phone,
        :birthday_string, :avatar, :delete_avatar, :user_id,
        :facebook, :spotify, :lastfm,
        legacy_profile_attributes: [
          :id, :buzzcard_id, :buzzcard_fc,
          team_ids: [], show_ids: []
        ]
      ]

      if Rails.env.development?
        permitted << [:current_password, :password, :password_confirmation]
      end

      # required for settings form to submit when password is left blank
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end

      params.require(:user).permit(permitted)
    end
end