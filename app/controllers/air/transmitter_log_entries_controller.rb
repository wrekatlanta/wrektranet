class Air::TransmitterLogEntriesController < Air::BaseController
  load_and_authorize_resource except: [:delete]

  def index
    @tlogs = TransmitterLogEntry.today
  end

  def create
    @tlog = TransmitterLogEntry.new()
    @tlog.user = current_user
    @tlog.sign_in = Time.zone.now
    @tlog.automation_in = transmitter_log_entry_params[:automation_in]

    if @tlog.save
      redirect_to air_transmitter_log_entries_path, success: "You have signed in."
    else
      redirect_to air_transmitter_log_entries_path, error: "Something has gone awry."
    end
  end


  private
    def transmitter_log_entry_params
      params.require(:transmitter_log_entry).permit(
       :automation_in, :automation_out, :sign_out
      )
    end

end