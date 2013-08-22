class Admin::ContestsController < Admin::BaseController
  load_and_authorize_resource except: [:create]

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
    @contest = Contest.new(contest_params)
    authorize! :create, @contest

    if @contest.save
      redirect_to admin_contests_path, success: "#{@contest.name} created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @contest.update_attributes(contest_params)
      redirect_to admin_contests_path, success: "#{@contest.name} updated successfully."
    else
      render :edit
    end
  end

  def destroy
  end

  private
    def contest_params
      params.require(:contest).permit(
        :name, :date, :venue_id, :age_limit,
        :listener_ticket_limit, :listener_plus_one,
        :staff_ticket_limit, :staff_plus_one,
        :notes
      )
    end
end