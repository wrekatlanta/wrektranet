class Air::PsasController < Air::BaseController
  load_and_authorize_resource except: [:create]

  def index
    @psas = @psas.approved

  end

  def show
  end
end