source 'http://rubygems.org'

gem 'rails', '3.0.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
group :test, :development do
	gem 'cucumber-rails'
	gem 'rspec-rails'
    gem 'capybara'
	gem 'cucumber'
	gem 'autotest'
	gem 'factory_girl_rails'
end

gem "nifty-generators", :group => :development
gem "devise"
gem "jquery-rails", "0.2.7" #nifty generators will not work with version above this


gem "mocha", :group => :test

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

group :production do
  gem 'passenger'
end
# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
