namespace :import do
  require 'nokogiri'

  task :users do
    f = File.open(Rails.root.join('lib', 'tasks', 'staff.html'))
    doc = Nokogiri::HTML(f)

    f.close
  end
end