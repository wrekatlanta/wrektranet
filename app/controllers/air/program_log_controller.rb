class Air::ProgramLogController < Air::BaseController
  def index
    @time = params[:time].blank? ? Time.zone.now : Chronic.parse(params[:time])
    @day = @time.beginning_of_day
    @program_log = ProgramLog.generate(@time)
    @schedule = Legacy::Schedule.generate_for_day(@time)
  end
end