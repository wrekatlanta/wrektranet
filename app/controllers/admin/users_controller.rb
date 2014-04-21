class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource except: [:index]
  respond_to :json, :html

  def index
    authorize! :manage, User

    @roles = Role.all
    @teams = Legacy::Team.all
    @shows = Legacy::Show.specialty_shows
    @users = User.includes(:roles, legacy_profile: [:teams, :shows])
  end

  def edit
  end

  def update
    password = user_params[:password]

    if @user.update_attributes(user_params) and @user.sync_to_legacy_profile!(password) and @user.sync_to_ldap(password)
      redirect_to admin_users_path, success: "#{@user.username} updated successfully."
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, success: "#{@user.username} deleted successfully."
    else
      render :edit
    end
  end

  private
    def user_params
      # remove password if blank
      params[:user][:password] = nil if params[:user][:password].blank?

      permitted = [
        :username, :email, :subscribed_to_announce, :subscribed_to_staff,
        :first_name, :middle_name, :last_name, :display_name, :password,
        :user_id, :status, :birthday_string, :avatar, :delete_avatar,
        :phone, :admin, :exec_staff, role_ids: [],
        legacy_profile_attributes: [
          :id, :door1_access, :door2_access, :door3_access,
          :door4_access, :buzzcard_id, :buzzcard_fc
        ]
      ]

      params.require(:user).permit(permitted)
    end
end