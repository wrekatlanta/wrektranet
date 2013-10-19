class Staff::ListenerLogsController < Staff::BaseController
  require 'nokogiri'
  require 'open-uri'
  respond_to :json, :html
  load_and_authorize_resource except: [:create, :edit, :show]


  def index
    listener_logs = ListenerLog.today

    @hd2_128 = listener_logs.map { |log| [log.created_at.to_i * 1000, log.hd2_128] }
    @main_128 = listener_logs.map { |log| [log.created_at.to_i * 1000, log.main_128] }
    @main_24 = listener_logs.map { |log| [log.created_at.to_i * 1000, log.main_24] }
    
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
