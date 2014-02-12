class Air::AlbumsController < Air::BaseController
  respond_to :json

  def show
    @album = Legacy::Album
      .includes(:organization, tracks: [:format, :play_logs])
      .find(params[:id])
  end

  def index
    @albums = Legacy::Album.includes(:organization)

    if params[:album_title]
      @albums = @albums.where("upper(album_title) LIKE upper(?)", "%#{params[:album_title]}%")
    end

    if params[:performance_by]
      @albums = @albums.where("upper(performance_by) LIKE upper(?)", "%#{params[:performance_by]}%")
    end

    if params[:org_name]
      @albums = @albums
        .where("upper(organizations.org_name) LIKE upper(?)", "%#{params[:org_name]}%")
    end

    @albums = @albums.limit(20)
  end
end
