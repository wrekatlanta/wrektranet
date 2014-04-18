class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource except: [:create]

  def index
    authorize! :manage, User

    @users = @users.includes(:roles, :legacy_profile)
  end

  def new
  end

  # to be replaced with a new user form that everyone can access
  def create
    @user = User.new(user_params)
    authorize! :create, @user

    @user.password = Devise.friendly_token[0,20]

    if @user.save
      # Invite user
      puts "user saved"
      @user.invite!
      redirect_to admin_users_path, success: "#{@user.username} created successfully. They have received an email with further instructions."
    else
      puts @user.errors.full_messages
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
      permitted = [
        :username, :email, :first_name, :middle_name, :last_name, :display_name,
        :phone, :admin, :exec_staff, role_ids: []
      ]

      params.require(:user).permit(permitted)
    end
end