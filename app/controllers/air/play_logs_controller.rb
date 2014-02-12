class Air::PlayLogsController < Air::BaseController
  respond_to :json

  def index
    @play_logs = Legacy::PlayLog
      .includes(:staff, track: [:format, album: [:organization]])
      .recent.limit(30).up_to(1.hour)
  end

  def create
  end
end