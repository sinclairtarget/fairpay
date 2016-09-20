ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# require all test helpers in /support
Dir[File.dirname(__FILE__) + '/support/*.rb'].each { |file| require file }

class ActiveSupport::TestCase
end
