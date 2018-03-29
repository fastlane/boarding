# Load the Rails application.
require File.expand_path('../application', __FILE__)

require "dotenv"
Dotenv.load ".env.local", ".env.#{Rails.env}"

# Initialize the Rails application.
Rails.application.initialize!
