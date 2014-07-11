class Staff::UsersController < Staff::BaseController
  load_and_authorize_resource
  respond_to :json, :html

  def index
    @roles = Role.all
    @teams = Legacy::Team.all
    @shows = Legacy::Show.specialty_shows
    @users = User.includes(:roles, legacy_profile: [:teams, :shows])
  end

  def show
  end

  def new
  end

  def create
    # stub
  end

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
        :user_id, :status, :birthday_string, :phone,
        :admin, :exec_staff, role_ids: [],
        legacy_profile_attributes: [
          :buzzcard_id, :buzzcard_fc
        ]
      ]

      # if database authenticatable, we need the password
      if Rails.env.development?
        permitted << :password
      end

      params.require(:user).permit(permitted)
    end
end