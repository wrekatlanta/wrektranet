class Air::ContestsController < Air::BaseController
  respond_to :html, :json
  load_and_authorize_resource except: [:create]

  def index
    @contests = @contests.
      includes(:venue).
      paginate(page: params[:page], per_page: 30).
      announceable.
      up_to(2.weeks)

    @contests = @contests.decorate
  end

  def show
    @contest = @contest.decorate
  end
end