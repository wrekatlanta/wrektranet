class Air::CallsController < Air::BaseController
  load_and_authorize_resource except: [:create]

  def index
    @calls = @calls

  end

  def show
  end
end
