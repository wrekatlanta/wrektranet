class Air::TransmitterLogEntriesController < Air::BaseController
  respond_to :json, :html

  load_and_authorize_resource :transmitter_log_entry, except: [:delete, :create]

  def index
    @tlogs = TransmitterLogEntry.today

    respond_with @tlogs, include: :user
  end

  def create
    @tlog = TransmitterLogEntry.new(transmitter_log_entry_params)
    authorize! :create, @tlog

    @tlog.user = current_user
    
    @tlog.save

    respond_with :air, @tlog
  end

  def update
    puts transmitter_log_entry_params
    if @transmitter_log_entry.update(transmitter_log_entry_params)
      redirect_to air_transmitter_log_entries_path, success: "Successfully updated the transmitter log."
    else
      redirect_to unsigned_air_transmitter_log_entries_path, error: "Could not update the Transmitter Log."
    end
  end

  def unsigned
    @tlogs = TransmitterLogEntry.unsigned.where(user: current_user)
  end


  private
    def transmitter_log_entry_params
      params.require(:transmitter_log_entry).permit(:sign_in, :automation_in, :automation_out, :sign_out)
    end

end