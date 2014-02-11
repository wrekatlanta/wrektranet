class Air::AlbumsController < Air::BaseController
  respond_to :json

  def show
    render json: Legacy::Album.find(params[:id]).to_json({
      include: [:tracks, :organization]
    })
  end
end
