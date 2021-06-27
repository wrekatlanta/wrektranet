# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
puts 'ROLES'
Role::DEFAULT_ROLES.each do |role|
  r = Role.find_or_initialize_by(name: role[:name])
  r.full_name = role[:full_name]
  r.save

  puts "role: #{r.full_name}"
end

# puts 'SETTINGS'
# Setting.save_default(:contest_book_enabled?, true)
# Setting.save_default(:transmitter_log_enabled?, true)
# Setting.save_default(:freehand_playlist_enabled?, true)
# Setting.save_default(:live_playlist_enabled?, true)
# Setting.save_default(:psa_book_enabled?, true)
# Setting.save_default(:listener_log_enabled?, true)
# Setting.save_default(:program_log_enabled?, true)
# Setting.save_default(:calendar_enabled?, true)
# Setting.save_default(:profiles_enabled?, true)

# # transmitter log
# Setting.save_default('transmitter_log.plate_curr_min', 2)
# Setting.save_default('transmitter_log.plate_curr_max', 3)
# Setting.save_default('transmitter_log.plate_volt_min', 9)
# Setting.save_default('transmitter_log.plate_volt_max', 10)
# Setting.save_default('transmitter_log.power_out_min', 16)
# Setting.save_default('transmitter_log.power_out_max', 17)

unless Rails.env.production?
  puts 'DEFAULT USERS'
  user = User.find_or_initialize_by(username: 'gpb')
  user.email ||= 'gpb@fake.me'
  user.first_name = 'George'
  user.last_name = 'Burdell'
  user.username = 'gpb'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.admin = true
  user.save

  puts 'user: ' << user.name
end
