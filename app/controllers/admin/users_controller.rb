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
    password = params[:user][:password]

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
      if params[:user][:password].blank?
        params[:user][:password] = nil
      end

      permitted = [
        :username, :email, :subscribed_to_announce, :subscribed_to_staff,
        :first_name, :middle_name, :last_name, :display_name,
        :user_id, :status, :birthday_string, :avatar, :delete_avatar,
        :phone, :admin, :exec_staff, role_ids: [],
        legacy_profile_attributes: [
          :id, :door1_access, :door2_access, :door3_access,
          :door4_access, :buzzcard_id, :buzzcard_fc,
          :md_privileges, :auto_privileges
        ]
      ]

      # if database authenticatable, change the password on the model
      if Rails.env.development?
        permitted << :password
      end

      params.require(:user).permit(permitted)
    end
end