class Admin::PsasController < Admin::BaseController
  load_and_authorize_resource except: [:create]

  def index

    if params[:filter] == 'expired'
      @psas = @psas.expired
    else
      @psas = @psas.unexpired
    end

  end

  def edit
  end

  def create
    @psa = Psa.new(psa_params)
    authorize! :create, @psa

    if @psa.save
      redirect_to admin_psas_path, success: "#{@psa.title} created successfully."
    else
      render :new
    end
  end

  def update
    if @psa.update_attributes(psa_params)
      redirect_to admin_psas_path, success: "#{@psa.title} updated successfully."
    else
      render :edit
    end
  end

  def destroy
    if @psa.destroy
      redirect_to admin_psas_path, success: "#{@psa.title} deleted successfully."
    else
      render :edit
    end
  end

  private
    def psa_params
      params.require(:psa).permit(
        :title, :body, :status, :expiration_date
      )
    end
	
end