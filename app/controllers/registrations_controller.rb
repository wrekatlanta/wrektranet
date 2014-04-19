class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params) and @user.sync_to_legacy_profile! and @user.sync_to_ldap
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
        :email, :subscribed_to_announce, :subscribed_to_staff,
        :first_name, :middle_name, :last_name, :display_name,
        :password, :password_confirmation, :phone,
        :birthday_string, :avatar, :delete_avatar,
        legacy_profile_attributes: [:buzzcard_id, :buzzcard_fc]
      ]

      # required for settings form to submit when password is left blank
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end

      params.require(:user).permit(permitted)
    end
end