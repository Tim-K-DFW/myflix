source 'https://rubygems.org'

gem 'eventmachine', :git => 'git://github.com/eventmachine/eventmachine.git', :branch => 'master'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt-ruby', '3.1.2'
gem 'fabrication'
gem 'faker'
gem 'figaro'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'
gem 'unicorn'

group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '3.2.0'
  gem 'shoulda-matchers', require: false
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'capybara'
  gem 'capybara-email'
end

group :production do
  gem 'rails_12factor'
end
