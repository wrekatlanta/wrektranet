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
ENV['ROLES'].split(',').each do |role|
  Role.find_or_create_by_name(role)
  puts 'role: ' << role
end

puts 'DEFAULT USERS'
user = User.find_by(email: 'gpb@wrek.org') || User.new
user.email = 'gpb@wrek.org'
user.first_name = 'George'
user.last_name = 'Burdell'
user.username = 'gpb'
user.password = 'password'
user.password_confirmation = 'password'
user.admin = true
user.save

puts 'user: ' << user.name