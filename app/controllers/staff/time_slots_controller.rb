class Staff::TimeSlotsController < Staff::BaseController
  respond_to :html, :json
  load_and_authorize_resource :time_slot, except: [:create, :me]

  def index
    @time_slots = @time_slots
    .paginate(page: params[:page], per_page:30).
    :decorate
  end

  def me
    @time_slots = current_user.
      time_slots.
      paginate(page: params[:page], per_page: 30).
      decorate

    render :index
  end

  def new
    @contests = Contest.
      announceable.
      without_user(current_user).
      decorate
  end

  def create
    @time_slot = current_user.time_slots.new(time_slot_params)
    authorize! :create, StaffTicket

    @time_slot.save

    respond_with @time_slot, location: me_time_slots_path
  end

  def destroy
    if @time_slot.destroy
      respond_with @time_slot, success: true, location: me_time_slots_path
    end
  end

  private
    def time_slot_params
      params.require(:time_slot).permit(:contest, :commit, :contest_id)
    end
end
