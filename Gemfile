source 'https://rubygems.org'

# ruby '2.3.3'

# Updated for CVE-2018-16476: https://nvd.nist.gov/vuln/detail/CVE-2018-16476.
gem 'activejob', '>= 4.2.11'

gem 'rack', '>= 1.6.11'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Vulnerable versions: >= 5.0.0, <= 5.0.7.1 
gem "actionview", ">= 5.0.7.2"

# Specify a sub-dependency of Rails
# As there is a security vulnerability
# in old versions of the library
gem "loofah", ">= 2.2.3"

# Use jquery as the JavaScript library

gem 'jquery-rails'

gem 'fastlane', '>= 2.126.0', '< 3.0.0'

gem 'bootstrap-sass', '~> 3.4.1'

# nokogiri 1.8.1 seems to be problematic
gem 'nokogiri', '>= 1.8.1', '< 2.0.0'

gem 'http_accept_language', '~> 2.0.5'

gem 'dotenv'

group :production do
  gem 'puma'
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # make sure our code is spick and span
  gem 'rubocop', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end
