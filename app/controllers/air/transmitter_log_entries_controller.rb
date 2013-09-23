class Air::TransmitterLogEntriesController < Air::BaseController
  load_and_authorize_resource except: [:delete]

  def index
    @tlogs = TransmitterLogEntry.today
  end

  def create
    @tlog = TransmitterLogEntry.new(transmitter_log_entry_params)
    @tlog.user = current_user
    @tlog.sign_in = Time.zone.now

    if @tlog.save
      redirect_to air_transmitter_log_entries_path, success: "You have signed in."
    else
      redirect_to air_transmitter_log_entries_path, error: "Something has gone awry."
    end
  end

  def update
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
      params.permit(:automation_in, :automation_out, :sign_out)
    end

end