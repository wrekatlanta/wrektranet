class Air::CallsController < Air::BaseController
  load_and_authorize_resource except: [:create]

  def index
    @calls = @calls.paginate(:page => params[:page], :per_page => 30)


  end

  def show
  end
end
