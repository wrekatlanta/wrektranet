class Staff::ContestSuggestionsController < Staff::BaseController
  load_and_authorize_resource :contest_suggestion, except: [:create]

  def index
    @contest_suggestions = @contest_suggestions.
      includes(:user).
      upcoming.
      paginate(page: params[:page], per_page: 30)
  end

  def new
  end

  def create
    @contest_suggestion = current_user.contest_suggestions.new(contest_suggestion_params)
    authorize! :create, @contest_suggestion

    if @contest_suggestion.save
      redirect_to staff_contest_suggestions_path, success: "Your suggestion has been added."
    else
      render :new
    end
  end

  private
    def contest_suggestion_params
      params.require(:contest_suggestion).permit(:name, :date_string, :venue)
    end
end