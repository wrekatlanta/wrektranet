class Admin::VenuesController < Admin::BaseController
  load_and_authorize_resource except: [:create]

  def index
    @venues = @venues.includes(:contacts)
  end

  def new
  end

  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      redirect_to admin_venues_path, success: "#{@venue.name} created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @venue.update_attributes(venue_params)
      redirect_to admin_venues_path, success: "#{@venue.name} updated successfully."
    else
      render :edit
    end
  end

  def destroy
  end

  private
    def venue_params
      params.require(:venue).permit(:name, :fax, :address, :send_day_offset, :send_hour, :send_minute, contacts_attributes: [:email, :id, '_destroy'])
      # FIXME: add :contact_attributes
    end
end