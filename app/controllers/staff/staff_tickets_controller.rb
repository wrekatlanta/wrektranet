class Staff::StaffTicketsController < Staff::BaseController
  load_and_authorize_resource :staff_ticket, except: [:destroy]

  def index
    @staff_tickets = @staff_tickets.
      upcoming.
      includes(:user).
      paginate(page: params[:page], per_page: 30).
      decorate
  end

  def new
  end

  def create
  end

  def destroy
  end

  private
    def staff_ticket_params
      params.require(:staff_ticket).permit(:contest)
    end
end