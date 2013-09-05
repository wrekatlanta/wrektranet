class Air::TransmitterLogEntriesController < Air::BaseController
  load_and_authorize_resource except: [:delete]

  def index
    @tlogs = TransmitterLogEntry.today
  end

  def create
    
  end

end