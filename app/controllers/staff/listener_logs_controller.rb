class Staff::ListenerLogsController < Staff::BaseController
  require 'open-uri'
  respond_to :json, :html
  load_and_authorize_resource except: [:create, :edit, :show, :current]


  def index
    start_date = params[:start].blank? ? 24.hours.ago : Chronic.parse(params[:start])
    end_date = params[:end].blank? ? Time.zone.now : Chronic.parse(params[:end])

    @listener_logs = ListenerLog.range(start_date, end_date)

    @hd2_128 = @listener_logs.map { |log| [log.created_at.to_i * 1000, log.hd2_128] }
    @main_128 = @listener_logs.map { |log| [log.created_at.to_i * 1000, log.main_128] }
    @main_24 = @listener_logs.map { |log| [log.created_at.to_i * 1000, log.main_24] }
  end

  def hourly_averages
    start_date = params[:start].blank? ? 24.hours.ago : Chronic.parse(params[:start])
    end_date = params[:end].blank? ? Time.zone.now : Chronic.parse(params[:end])

    raw_logs = ListenerLog.range(start_date, end_date)
      .group_by { |log| log.created_at.beginning_of_hour }

    @listener_logs = []

    raw_logs.each do |hour, logs|
      next if logs.nil?
      aggregate = logs.first

      main_128 = logs.map(&:main_128).reduce(:+).to_f / logs.size
      main_24  = logs.map(&:main_24).reduce(:+).to_f / logs.size
      hd2_128  = logs.map(&:hd2_128).reduce(:+).to_f / logs.size

      aggregate.main_128 = main_128
      aggregate.main_24 = main_24
      aggregate.hd2_128 = hd2_128
      aggregate.created_at = aggregate.created_at.beginning_of_hour
      @listener_logs << aggregate
    end

    render :index
  end

  def current
    require 'json'

    url = "https://streaming.wrek.org/status-json.xsl"

    stats = JSON.load(URI.open(url))

    # JSON.parse(stats)
    listener_log = {}

    listener_log['hd2_128'] = Integer(stats["icestats"]["source"][0]["listeners"])
    listener_log['main_128'] = Integer(stats["icestats"]["source"][3]["listeners"])
    listener_log['main_24'] = Integer(stats["icestats"]["source"][4]["listeners"])

    respond_with listener_log

  end


end

