class Admin::StaffTicketsController < Admin::BaseController
  respond_to :html, :json
  load_and_authorize_resource except: [:create]

  def index
    authorize! :manage, StaffTicket

    if params.has_key?(:contest_id)
      @contest = Contest.find(params[:contest_id])
      @staff_tickets = @contest.staff_tickets
    else
      @staff_tickets = @staff_tickets.announceable
    end

    @staff_tickets = @staff_tickets.decorate
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
      include: [:user, {contest: {include: [:venue]}}]
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
      include: [:user, {contest: {include: [:venue]}}]
    })
  end

  def destroy
    if @staff_ticket.destroy
      respond_with success: true
    end
  end

  private
    def staff_ticket_params
      params.require(:staff_ticket).permit(:id, :display_name, :awarded, :user_id, :contest_director_id)
    end
end