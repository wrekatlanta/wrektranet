class Air::PlayLogsController < Air::BaseController
  respond_to :json

  def index
    #@play_logs = Rails.cache.fetch('recent_tracks') do
    @play_logs = Legacy::PlayLog.includes(:staff, track: [:format, album: [:organization]]).recent.limit(30)
    #end
  end

  def create
  end
end