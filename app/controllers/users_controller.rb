class UsersController < ApplicationController
  layout 'application'

  def help
    @user = User.new
  end

  def reset_password
    @user = User.find_by(username: user_params[:username])

    @user.send_reset_password_instructions
    flash[:notice] = "Reset password instructions have been sent to you. Contact wrektranet@wrek.org if you're still having problems."
    redirect_to new_user_session_path
  end

  # requires user's current username and password
  # this creates an LDAP entry if one doesn't exist
  # updates the password otherwise
  def fix_ldap
    @user = User.find_by(username: user_params[:username])
    
    if @user.blank?
      flash[:danger] = "Couldn't find that user."
      redirect_to help_users_path
      return
    elsif not @user.legacy_profile
      flash[:danger] = "Something's missing for that user, please send us an email!"
      redirect_to help_users_path
      return
    end

    password = user_params[:current_password]

    passwords_match = @user.legacy_profile.password == Legacy::Staff.legacy_password_hash(password)

    if passwords_match and @user.sync_to_legacy_profile!(password) and @user.sync_to_ldap(password)
      @user.password = password
      @user.save!

      flash[:notice] = "Things should hopefully be working now. Try it out!"
      redirect_to new_user_session_path
    else
      flash[:danger] = "Sorry, we couldn't match that password!"
      redirect_to help_users_path
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :current_password)
    end
end