class Air::ContestsController < Air::BaseController
  load_and_authorize_resource except: [:create]

  def index
    @contests = @contests.
      includes(:venue).
      paginate(page: params[:page], per_page: 30).
      announceable

    @contests = @contests.decorate
  end

  def show
  end
end