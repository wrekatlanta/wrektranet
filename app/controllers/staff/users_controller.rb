class Staff::UsersController < Staff::BaseController
  load_and_authorize_resource except: [:index]
  respond_to :json, :html

  def index
    @roles = Role.all
    @users = User.all.includes(:roles)
  end

  # def new
  # end

  # # to be replaced with a new user form that everyone can access
  # def create
  #   @user = User.new(user_params)
  #   authorize! :create, @user

  #   @user.password = Devise.friendly_token[0,20]

  #   if @user.save
  #     # Invite user
  #     puts "user saved"
  #     @user.invite!
  #     redirect_to admin_users_path, success: "#{@user.username} created successfully. They have received an email with further instructions."
  #   else
  #     puts @user.errors.full_messages
  #     render :new
  #   end
  # end

  private
    def user_params
      permitted = [
        :username, :email, :first_name, :middle_name, :last_name, :display_name,
        :birthday_string, :phone, :password, :password_confirmation
      ]

      params.require(:user).permit(permitted)
    end
end