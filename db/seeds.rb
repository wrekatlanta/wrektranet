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
  r = Role.find_or_initialize_by_name(role[:name])
  r.full_name = role[:full_name]
  r.save

  puts "role: #{r.full_name}"
end

unless Rails.env.production?
  puts 'DEFAULT USERS'
  user = User.find_or_initialize_by_username('gpb')
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