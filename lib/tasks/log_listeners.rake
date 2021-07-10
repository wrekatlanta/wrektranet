task :log_listeners => :environment do |t, args|
  # Not sure what this file is doing...
  require 'json'
  require 'open-uri'
  require 'listener_log'

  url = "https://streaming.wrek.org/status-json.xsl"

  stats = JSON.load(URI.open(url))

  listener_log = ListenerLog.new

  stats = stats.each_with_index.map {|stream, index| index == 0 ? stream.css('.streamdata')[5].text : stream.css('.streamdata')[4].text}

  listener_log.hd2_128 = Integer(stats["icestats"]["source"][0]["listeners"])
  listener_log.main_128 = Integer(stats["icestats"]["source"][3]["listeners"])
  listener_log.main_24 = Integer(stats["icestats"]["source"][4]["listeners"])

  listener_log.save

end