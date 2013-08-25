class Air::ListenerTicketsController < Air::BaseController
  respond_to :json

  load_and_authorize_resource :contest, except: [:destroy]
  load_and_authorize_resource :listener_ticket,
    through: :contest, shallow: true, except: [:create]

  def index
    respond_with @listener_tickets, include: :user
  end

  def create
    @contest = Contest.find(params[:contest_id])
    @listener_ticket = @contest.listener_tickets.new(listener_ticket_params)
    @listener_ticket.user = current_user

    authorize! :create, @listener_ticket
    @listener_ticket.save

    respond_with :air, @listener_ticket
  end

  def show
  end

  def destroy
    @listener_ticket.destroy

    respond_with @listener_ticket
  end

  private
    def listener_ticket_params
      params.require(:listener_ticket).permit(:name, :phone)
    end
end