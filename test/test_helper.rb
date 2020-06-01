ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  ActionDispatch::IntegrationTest
    Capybara.server_port = 3001
    Capybara.app_host = 'http://localhost:3001'
  end
end
