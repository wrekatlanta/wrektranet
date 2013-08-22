class Admin::VenuesController < Admin::BaseController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    if @venue.save
      redirect_to admin_venues_path, success: "#{@venue.name} created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def person_params
      params.require(:venue).permit(:name, :fax, :address,
        :send_day_offset, :send_hour, :send_minute)
      # FIXME: add :contact_attributes
    end
end