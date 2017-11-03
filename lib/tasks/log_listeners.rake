task :log_listeners => :environment do |t, args|
  require 'nokogiri'
  require 'open-uri'
  require 'listener_log'

  # Returns an element from a NodeSet that represents an HTML table at
  # a particular index.
  #
  # Keyword arguments:
  # table -- the NodeSet table to search
  # index -- the index of the element in the table
  def get_element_of_table(table, index)
    rows = table.children.first.children
    rows[index]
  end

  # Names of the container and table to extract listener data from
  container_name = '.roundbox'
  table_name = '.yellowkeys'
 
  url = "http://streaming.wrek.org:8000/"

  stats = Nokogiri::HTML(open(url)).css(container_name)[0..-1]

  listener_log = ListenerLog.new

  stats = stats.each_with_index.map { |stream, index|
    # The first table has the listener count at index 5 (the HD-2 stream).
    # All else are at index 4.
    table_index = index == 0 ? 5 : 4
    count_raw = get_element_of_table(stream.css(table_name)[0], table_index)
    count_raw.text.split(":")[1].to_i
  }

  # Insert the listener data into the log
  listener_log.hd2_128 = stats[0]
  listener_log.main_128 = stats[1]
  listener_log.main_24 = stats[2]

  listener_log.save
  
end
