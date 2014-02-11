class Air::AlbumsController < Air::BaseController
  respond_to :json

  def show
    @album = Legacy::Album
      .includes(:organization, tracks: [:format, :play_logs])
      .find(params[:id])
  end
end
