class Admin::StaffTicketsController < Admin::BaseController
  respond_to :html, :json
  load_and_authorize_resource except: [:create]

  def index
    @staff_tickets = @staff_tickets.
      upcoming.
      includes(:user).
      decorate
  end

  def update
    @staff_ticket.update_attributes(staff_ticket_params)

    respond_with @staff_ticket
  end

  private
    def staff_ticket_params
      params.require(:staff_ticket).permit(:contest_id, :awarded)
    end
end