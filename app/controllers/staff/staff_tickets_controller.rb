class Staff::StaffTicketsController < Staff::BaseController
  respond_to :html, :json
  load_and_authorize_resource :staff_ticket, except: [:create, :destroy, :me]

  def index
    @staff_tickets = @staff_tickets.
      upcoming.
      includes(:user).
      paginate(page: params[:page], per_page: 30).
      decorate
  end

  def me
    @staff_tickets = current_user.
      staff_tickets.
      paginate(page: params[:page], per_page: 30).
      decorate

    render :index
  end

  def new
    @contests = Contest.
      announceable.
      without_user(current_user).
      paginate(page: params[:page], per_page: 30).
      decorate
  end

  def create
    @staff_ticket = current_user.staff_tickets.new(staff_ticket_params)
    authorize! :create, StaffTicket

    @staff_ticket.save

    respond_with @staff_ticket, location: me_staff_tickets_path
  end

  def destroy
  end

  private
    def staff_ticket_params
      params.require(:staff_ticket).permit(:contest, :commit, :contest_id)
    end
end