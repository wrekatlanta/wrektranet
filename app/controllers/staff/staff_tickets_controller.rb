class Staff::StaffTicketsController < Staff::BaseController
  load_and_authorize_resource :staff_ticket, except: [:create, :destroy]

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
    @contests = Contest.announceable
  end

  def create
    @staff_ticket = current_user.staff_tickets.new(staff_ticket_params)
    authorize! :create, @staff_ticket

    if @staff_ticket.save
      redirect_to me_staff_tickets_path, success: "Successfully signed up for #{@staff_ticket.contest.name}."
    else
      render :new
    end
  end

  def destroy
  end

  private
    def staff_ticket_params
      params.require(:staff_ticket).permit(:contest, :commit, :contest_id)
    end
end