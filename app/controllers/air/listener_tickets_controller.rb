class Air::ListenerTicketsController < Air::BaseController
  respond_to :json

  load_and_authorize_resource :contest
  load_and_authorize_resource :listener_ticket,
    through: :contest, shallow: true, except: [:create]

  def index
    respond_with @listener_tickets
  end

  def create
    @contest = Contest.find(params[:contest_id])
    @listener_ticket = @contest.listener_tickets.new(user: current_user)
    authorize! :create, @listener_ticket

    respond_with @listener_ticket
  end

  def destroy
    @listener_ticket.destroy

    respond_with @listener_ticket
  end

  private
    def listener_ticket_params
      params.require(:listener_ticket)
    end
end