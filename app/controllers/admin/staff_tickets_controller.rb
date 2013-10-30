class Admin::StaffTicketsController < Admin::BaseController
  respond_to :html, :json
  load_and_authorize_resource except: [:create]

  def index
    if params.has_key?(:contest_id)
      @contest = Contest.find(params[:contest_id])
    end

    @staff_tickets = @staff_tickets
      .announceable
      .decorate
  end

  def create
    @staff_ticket = StaffTicket.new(staff_ticket_params)
    authorize! :create, @staff_ticket

    if params.has_key?(:contest_id)
      @contest = Contest.find(params[:contest_id])
      @staff_ticket.contest = @contest
    end

    @staff_ticket.contest_director = current_user
    @staff_ticket.awarded = true
    @staff_ticket.save

    render json: @staff_ticket.to_json({
      include: [:user, {contest: {include: [:venue, :event]}}]
    })
  end

  def update
    if staff_ticket_params[:awarded]
      staff_ticket_params.merge!(contest_director_id: current_user.id)
    else
      staff_ticket_params.merge!(contest_director_id: nil)
    end

    @staff_ticket.update_attributes!(staff_ticket_params)

    render json: @staff_ticket.to_json({
      include: [:user, {contest: {include: [:venue, :event]}}]
    })
  end

  private
    def staff_ticket_params
      params.require(:staff_ticket).permit(:id, :awarded, :user_id)
    end
end