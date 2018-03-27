require "dotenv"
Dotenv.load ".env.local", ".env.#{Rails.env}"
puts "ENV: .env.#{Rails.env}"

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
