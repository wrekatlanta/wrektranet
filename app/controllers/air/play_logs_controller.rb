class Air::PlayLogsController < Air::BaseController
  respond_to :json

  def index
    @play_logs = Rails.cache.fetch('recent_tracks') do
      Legacy::PlayLog
        .recent
        .includes(track: [:format, album: [:organization]])
        .limit(30)
    end
  end

  def create
  end
end