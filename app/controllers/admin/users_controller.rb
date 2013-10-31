class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource except: [:create]

  def index
    authorize! :manage, User

    @users = @users.
      includes(:roles).
      paginate(page: params[:page], per_page: 30)
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
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
      params.require(:user).permit(
        :admin, role_ids: []
      )
    end
end