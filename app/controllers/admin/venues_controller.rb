class Admin::VenuesController < Admin::BaseController
  load_and_authorize_resource except: [:create]

  def index
    authorize! :manage, Venue

    @venues = @venues.
      includes(:contacts).
      paginate(page: params[:page], per_page: 30)
  end

  def new
  end

  def create
    @venue = Venue.new(venue_params)
    authorize! :create, @venue

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
    if @venue.destroy
      redirect_to admin_venues_path, success: "#{@venue.name} deleted successfully."
    else
      render :edit
    end
  end

  private
    def venue_params
      params.require(:venue).permit(
        :name, :fax, :address, :send_day_offset,
        :send_hour, contacts_attributes: [:email, :id, '_destroy']
      )
    end
end