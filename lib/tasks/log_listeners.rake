task :log_listeners => :environment do |t, args|
  require 'nokogiri'
  require 'open-uri'
  require 'listener_log'

  url = "https://streaming.wrek.org/"

  stats = Nokogiri::HTML(open(url)).css('.roundcont')[1..-1]

  listener_log = ListenerLog.new

  stats = stats.each_with_index.map {|stream, index| index == 0 ? stream.css('.streamdata')[5].text : stream.css('.streamdata')[4].text}

  listener_log.hd2_128 = stats[0]
  listener_log.main_128 = stats[1]
  listener_log.main_24 = stats[2]

  listener_log.save

end