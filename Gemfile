source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', github: 'rails/rails', branch: '4-0-stable'
gem 'sass-rails', '~> 4.0.0'
gem 'slim'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'unicorn'

group :doc do
  gem 'sdoc', require: false
end

gem 'bootstrap-sass', git: 'git://github.com/thomas-mcdonald/bootstrap-sass.git', branch: '3'
gem 'active_link_to'
gem 'cancan'
gem 'devise', '~> 3.0.x'
gem 'omniauth'
gem 'figaro'
gem 'pg'
gem 'rolify', '~> 3.3.0.rc4'
gem 'draper', '~> 1.0'
gem 'simple_form', git: 'git://github.com/plataformatec/simple_form.git'
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap'
gem 'whenever'
gem 'nokogiri'

# time helpers
gem 'chronic'
gem 'tod'

# APIs
gem 'omniauth-google-apps'
gem 'google-api-client'

group :development do
  gem 'guard', '>=2.1.0'
  gem 'unicorn-rails'
  gem 'better_errors'
  gem 'annotate', '>= 2.5.0'
  gem 'binding_of_caller'
  gem 'guard-bundler'
  gem 'guard-cucumber'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'haml-rails'
  gem 'haml2slim'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'letter_opener'
end

group :development, :test do
  gem 'simplecov', '~> 0.8.0.pre2', require: false
  gem 'factory_girl_rails'
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
  gem 'unicorn'
  gem 'rails_12factor' # For asset compilation
end
