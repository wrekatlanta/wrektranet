source 'https://rubygems.org'
ruby '2.5.9'

gem 'rails', '~> 5.0.7'

gem 'unicorn'
gem 'capistrano'
gem 'rvm-capistrano', require: false

gem 'sassc-rails'
gem 'slim'
gem 'uglifier', '>= 1.3.0'
gem 'json', '>= 2.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'yajl-ruby'

# group :doc do
#   gem 'sdoc', require: false
# end

gem 'mysql2', '~> 0.4.10'
gem 'net-ldap'

# gem 'sentry-ruby'

# devise
gem 'devise'
gem 'devise_invitable'
gem 'devise_ldap_authenticatable'
gem 'cancan'

# gem 'bootstrap-sass'
gem 'bootstrap'
gem 'active_link_to'
# gem 'figaro', github: 'laserlemon/figaro'
gem 'rolify'
gem 'draper', '~> 3.0'
gem 'simple_form'
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap'
gem 'whenever'
gem 'nokogiri'
gem 'open-uri'
gem 'redcarpet'
gem 'validate_url'
gem 'paperclip', '~> 4.1'
gem 'rails-settings-cached'

# time helpers
gem 'chronic'
gem 'tod'
gem 'ice_cube'
gem 'ri_cal'

group :development do
  gem 'guard', '>=2.1.0'
  gem 'raindrops', '>=0.13.0'
  gem 'better_errors'
  gem 'annotate', '>= 2.5.0'
  gem 'binding_of_caller'
  # gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'haml-rails'
  gem 'haml2slim'
  gem 'html2haml'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'letter_opener'
end

group :development, :test do
  gem 'simplecov', require: false
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'launchy'
end

group :production do
  gem 'rails_12factor' # For asset compilation
  gem 'unicorn-rails'
end

# optional, only useful for playlists/AudioVault: `bundle install --without=oracle`
# https://github.com/wrekatlanta/wrektranet/wiki/Installing-Oracle-adapters
# group :oracle do
#   gem 'activerecord-oracle_enhanced-adapter', '~> 1.7.0'
#   gem 'ruby-oci8'
# end
