# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../app', __FILE__)
require 'http_accept_language'
use HttpAcceptLanguage::Middleware
run Boarding
