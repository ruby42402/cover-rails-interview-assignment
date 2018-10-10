ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # monkey patch for testing sidekiq-unique-jobs
  def clear_unique_from_redis
    redis = Redis.new
    keys = redis.scan(0, :match => "unique*").last
    redis.del(keys) if !keys.empty?
  end
end
