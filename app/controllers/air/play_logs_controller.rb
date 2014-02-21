class Air::PlayLogsController < Air::BaseController
  respond_to :json

  def index
    @play_logs = Legacy::PlayLog
      .includes(:staff, track: [:format, album: [:organization]])
      .recent.limit(30).up_to(1.hour)
  end

  def create
    @play_log = Legacy::PlayLog.new(play_log_params)
    authorize! :create, @play_log

    # set to automation by default
    @play_log.played_by = current_user.legacy_id || -1
    @play_log.playtime = Time.zone.now
    @play_log.save

    render json: @play_log.to_builder.target!
  end

  def destroy
    @play_log = Legacy::PlayLog.find(params[:id])
    authorize! :destroy, @play_log

    if @play_log.destroy
      respond_with success: true
    end
  end

  def adjust_time
    @play_log = Legacy::PlayLog.find(params[:id])
    authorize! :update, @play_log

    offset = params["minutes"].to_i

    if offset >= -10 and offset <= 10
      @play_log.adjust_time!(offset.minutes)
    end

    render json: @play_log.to_builder.target!
  end

  private
    def play_log_params
      params.require(:play_log).permit(:track_id)
    end
end