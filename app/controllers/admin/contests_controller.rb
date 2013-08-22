class Admin::ContestsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @contests = @contests.
      includes(:venue).
      paginate(page: params[:page], per_page: 30)

    if params[:filter] == 'past'
      @contests = @contests.past
    else
      @contests = @contests.upcoming
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end