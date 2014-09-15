class Air::ContestsController < Air::BaseController
  respond_to :html, :json
  load_and_authorize_resource except: [:create]

  def index
    if params[:filter] == 'past'
      @contests = @contests.past
    elsif current_user.admin?
      @contests = @contests.announceable.up_to(3.months) 
    else
      @contests = @contests.announceable.up_to(2.weeks)
    end

    @contests = @contests
      .includes(:venue)
      .paginate(page: params[:page], per_page: 50)
      .decorate
      
    @contest_days = @contests.group_by { |c| c.send_time.beginning_of_day }.sort

    if params[:filter] == 'past'
      @contest_days.reverse!
    end
  end

  def show
    @contest = @contest.decorate
  end
end
