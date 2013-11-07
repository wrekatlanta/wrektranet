class Admin::TransmitterLogEntriesController < Admin::BaseController


  def index
    @tlogs = TransmitterLogEntry.unsigned
  end


end
