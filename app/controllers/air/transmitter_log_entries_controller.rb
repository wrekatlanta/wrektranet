class Air::TransmitterLogEntriesController < Air::BaseController
  respond_to :json, :html

  load_and_authorize_resource :transmitter_log_entry, except: [:delete, :create, :unsigned]

  def index
    @tlogs = TransmitterLogEntry.today

    respond_with @tlogs, include: :user
  end

  def archive
    start_date = params[:start].blank? ? Time.zone.today : Chronic.parse(params[:start])
    end_date = params[:end].blank? ? Time.zone.today : Chronic.parse(params[:end])

    @tlogs = TransmitterLogEntry
                .between(start_date.beginning_of_day, end_date.end_of_day)
                .group_by { |log| log.sign_in.to_date }
                .sort
  end

  def create
    @tlog = TransmitterLogEntry.new(transmitter_log_entry_params)
    # Workaround due to cancan bug in load_and_authorize_resource stepping on strong params toes
    authorize! :create, @tlog

    @tlog.user = current_user
    
    @tlog.save

    respond_with :air, @tlog
  end

  def update
    if @transmitter_log_entry.update(transmitter_log_entry_params)
      respond_with @transmitter_log_entry, success: "Successfully updated the transmitter log."
    else
      respond_with @transmitter_log_entry, error: "Could not update the Transmitter Log."
    end
  end

  def unsigned
    @tlogs = TransmitterLogEntry.unsigned.where(user: current_user)
    authorize! :read, @tlogs

  end


  private
    def transmitter_log_entry_params
      params.require(:transmitter_log_entry).permit(:sign_in, :automation_in, :automation_out, :sign_out)
    end

end