class Air::ProgramLogController < Air::BaseController
  def index
    unless params[:time].blank?
      @time = Chronic.parse(params[:time])
      @custom_time_set = true
    end

    unless params[:limit_hours].blank?
      @limit = params[:limit_hours].to_i.hours
    end

    @time ||= Time.zone.now
    @custom_time_set ||= false
    @limit ||= ProgramLog::DEFAULT_LIMIT
    @limit_in_hours = @limit / 1.hour

    @day = @time.beginning_of_day
    @program_log = ProgramLog.generate(@time, limit: @limit)
    @schedule = Legacy::Schedule.generate_for_day(@time)
  end
end