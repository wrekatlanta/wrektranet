class Air::PsaReadingsController < Air::BaseController
  load_and_authorize_resource except: [:destroy]

  def create
  	psa = Psa.find(params[:psa_id])
  	psa_reading = PsaReading.new
  	psa_reading.user = current_user
  	psa_reading.psa = psa
  	psa_reading.save
  	
  	redirect_to air_psas_url
  end
end