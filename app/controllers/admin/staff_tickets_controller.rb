class Admin::StaffTicketsController < Admin::BaseController
  respond_to :html, :json
  load_and_authorize_resource except: [:create]

  def index
    @staff_tickets = @staff_tickets
      .announceable
      .includes(:user)
      .includes(contest: :venue)
      .decorate
  end

  def update
    if staff_ticket_params[:awarded]
      staff_ticket_params.merge!(contest_director_id: current_user.id)
    else
      staff_ticket_params.merge!(contest_director_id: nil)
    end

    @staff_ticket.update_attributes(staff_ticket_params)

    render json: @staff_ticket.to_json({
      include: [:user, {contest: {include: :venue}}]
    })
  end

  private
    def staff_ticket_params
      params.require(:staff_ticket).permit(:id, :awarded)
    end
end