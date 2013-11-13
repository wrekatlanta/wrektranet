class Admin::TransmitterLogEntriesController < Admin::BaseController

  load_and_authorize_resource :transmitter_log_entry


  def index

    start_date = params[:start].blank? ? Time.zone.today : Chronic.parse(params[:start])
    end_date = params[:end].blank? ? Time.zone.today : Chronic.parse(params[:end])

    tlogs = TransmitterLogEntry.where("sign_in >= ?", start_date.beginning_of_day).where("sign_out <= ? OR sign_out is NULL", end_date.end_of_day)

    @day_view = TransmitterLogEntry.bucket_format(tlogs)

  end

  def unsigned
    @tlogs = TransmitterLogEntry.unsigned
  end

end
