class Staff::ListenerLogsController < Staff::BaseController

  def index
    listener_logs = ListenerLog.today

    @hd2_128 = listener_logs.map { |log| [log.created_at.to_i * 1000, log.hd2_128] }
    @main_128 = listener_logs.map { |log| [log.created_at.to_i * 1000, log.main_128] }
    @main_24 = listener_logs.map { |log| [log.created_at.to_i * 1000, log.main_24] }
    
  end

  
end
