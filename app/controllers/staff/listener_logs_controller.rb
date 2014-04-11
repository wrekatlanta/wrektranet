class Staff::ListenerLogsController < Staff::BaseController
  require 'nokogiri'
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
    
    url = "http://streaming.wrek.org:8000/"

    stats = Nokogiri::HTML(open(url)).css('.roundcont')[1..-1]

    listener_log = {}

    stats = stats.each_with_index.map {|stream, index| index == 0 ? stream.css('.streamdata')[5].text : stream.css('.streamdata')[4].text}

    listener_log['hd2_128'] = stats[0]
    listener_log['main_128'] = stats[1]
    listener_log['main_24'] = stats[2]

    respond_with listener_log
    
  end

  
end
