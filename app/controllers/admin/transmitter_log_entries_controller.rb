class Admin::TransmitterLogEntriesController < Admin::BaseController
  load_and_authorize_resource :transmitter_log_entry

  def index
    start_date = params[:start].blank? ? Time.zone.today : Chronic.parse(params[:start])
    end_date = params[:end].blank? ? Time.zone.today : Chronic.parse(params[:end])

    @tlogs_by_day = TransmitterLogEntry
              .between(start_date.beginning_of_day, end_date.end_of_day)
              .group_by { |log| log.sign_in.to_date }
              .sort
  end

  def archive
    start_date = params[:start].blank? ? Time.zone.today : Chronic.parse(params[:start])
    end_date = params[:end].blank? ? Time.zone.today : Chronic.parse(params[:end])

    @tlogs = TransmitterLogEntry
                .between(start_date.beginning_of_day, end_date.end_of_day)
                .group_by { |log| log.sign_in.to_date }
                .sort
  end

  def unsigned
    @tlogs = TransmitterLogEntry.unsigned
  end

end
