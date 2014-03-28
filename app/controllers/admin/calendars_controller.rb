class Admin::CalendarsController < Admin::BaseController
  load_and_authorize_resource except: [:create]

  def index
    authorize! :manage, Contest

    @calendars = @calendars
      .paginate(page: params[:page], per_page: 30)
  end

  def edit
  end

  def create
    @calendar = Calendar.new(calendar_params)
    authorize! :create, @calendar

    if @calendar.save
      redirect_to admin_calendars_path, success: "#{@calendar.name} created successfully."
    else
      render :new
    end
  end

  def update
    if @calendar.update_attributes(calendar_params)
      redirect_to admin_calendars_path, success: "#{@calendar.name} updated successfully."
    else
      render :edit
    end
  end

  def destroy
    if @calendar.destroy
      redirect_to admin_calendars_path, success: "#{@calendar.name} deleted successfully."
    else
      render :edit
    end
  end

  private
    def calendar_params
      params.require(:calendar).permit(
        :url, :name, :default_location, :weeks_to_show
      )
    end
end