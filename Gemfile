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
gem 'poltergeist'

group :doc do
  gem 'sdoc', require: false
end

gem 'bootstrap-sass', git: 'git://github.com/thomas-mcdonald/bootstrap-sass.git', branch: '3'
gem 'active_link_to'
gem 'cancan'
gem 'devise', '~> 3.0.x'
gem 'devise_ldap_authenticatable', '~> 0.8.x'
gem 'figaro'
gem 'pg'
gem 'rolify', '~> 3.3.0.rc4'
gem 'draper', '~> 1.0'
gem 'simple_form', git: 'git://github.com/plataformatec/simple_form.git'
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap'
gem 'chronic'
gem 'whenever'

group :development do
  gem 'unicorn-rails'
  gem 'better_errors'
  gem 'annotate', '>= 2.5.0'
  gem 'binding_of_caller', platforms: [:mri_19, :rbx]
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
  gem 'simplecov', require: false
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'launchy'
end

group :production do
  gem 'unicorn'
  gem 'rails_12factor' # For asset compilation
end
