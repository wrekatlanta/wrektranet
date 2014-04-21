class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)
    password = account_update_params[:password]

    if @user.update_with_password(account_update_params) and @user.sync_to_legacy_profile!(password) and @user.sync_to_ldap(password)
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
        :first_name, :middle_name, :last_name, :display_name,
        :current_password, :password, :password_confirmation, :phone,
        :birthday_string, :avatar, :delete_avatar, :user_id,
        :facebook, :spotify, :lastfm,
        legacy_profile_attributes: [
          :id, :buzzcard_id, :buzzcard_fc,
          team_ids: [], show_ids: []
        ]
      ]

      # required for settings form to submit when password is left blank
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end

      params.require(:user).permit(permitted)
    end
end