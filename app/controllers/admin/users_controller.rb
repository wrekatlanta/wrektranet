class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource except: [:create]

  def index
    authorize! :manage, User

    @users = @users.
      includes(:roles).
      paginate(page: params[:page], per_page: 100)
  end

  def new
  end

  def create
    @user = User.new(user_params)
    authorize! :create, @user

    password = Devise.friendly_token[0,20]
    @user.password = password

    if @user.save
      redirect_to admin_users_path, success: "#{@user.username} created successfully. They have received an email with further instructions."
    else
      render :new
    end
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
      params.require(:user).permit(:username, :email,
                                   :first_name, :last_name, :display_name,
                                   :phone, :admin, role_ids: [])
    end
end