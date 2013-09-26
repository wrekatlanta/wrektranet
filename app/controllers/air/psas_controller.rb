class Air::PsasController < Air::BaseController
  load_and_authorize_resource except: [:create]

  def index
    @psas = @psas.unexpired.approved.order_by_read.reverse

  end

  def show
  end
end