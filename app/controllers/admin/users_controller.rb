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
      client = GoogleAppsHelper.create_client
      directory = client.discovered_api('admin', 'directory_v1')
      client.execute(
        api_method: directory.users.insert,
        body_object: {
          name: {
            familyName: @user.last_name,
            givenName: @user.first_name
          },
          password: password,
          primaryEmail: @user.username + '@wrek.org',
          changePasswordAtNextLogin: true,
          phones: [
            {
              primary: true,
              type: "mobile",
              value: @user.phone.presence || ''
            }
          ]
        }
      )

      UserMailer.import_email(@user, password, @user.email).deliver

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
      params.require(:user).permit(:username, :email, :first_name, :last_name, :phone, :admin, role_ids: [])
    end
end