class Air::PlaylistController < Air::BaseController
  def index
    @play_logs = Legacy::PlayLog.includes(track: [:format, album: [:organization]]).recent.limit(20)
  end
end