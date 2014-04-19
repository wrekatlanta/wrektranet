class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource except: [:index]
  respond_to :json, :html

  def index
    authorize! :manage, User

    @roles = Role.all

    respond_to do |format|
      format.html
      format.json { render json: User.all.includes(:roles).to_json(include: [:roles]) }
    end
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

  def edit
  end

  def update
    if @user.update_attributes(user_params) and @user.sync_to_legacy_profile!
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
        :username, :email, :subscribed_to_announce, :subscribed_to_staff,
        :first_name, :middle_name, :last_name, :display_name,
        :birthday_string, :avatar, :delete_avatar,
        :phone, :admin, :exec_staff, role_ids: [],
        legacy_profile_attributes: [
          :id, :door1_access, :door2_access, :door3_access,
          :door4_access, :buzzcard_id, :buzzcard_fc
        ]
      ]

      params.require(:user).permit(permitted)
    end
end