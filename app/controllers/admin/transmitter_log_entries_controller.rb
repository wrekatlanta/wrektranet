class Admin::TransmitterLogEntriesController < Admin::BaseController

  load_and_authorize_resource :transmitter_log_entry


  def index

    @tlogs = TransmitterLogEntry.all

    # Perform filtering if start and end are specified.
    if not params[:start].blank?
      @start = Chronic.parse(params[:start]).beginning_of_day
      @tlogs = @tlogs.where("sign_in >= ?", @start)
    end

    if not params[:end].blank?
      @end = Chronic.parse(params[:end]).end_of_day
      @tlogs = @tlogs.where("sign_out <= ?", @end)
    end

    # Otherwise give today
    if params[:end].blank? and params[:start].blank?
      @tlogs = TransmitterLogEntry.today
    end

  end

  def unsigned
    @tlogs = TransmitterLogEntry.unsigned
  end

end
