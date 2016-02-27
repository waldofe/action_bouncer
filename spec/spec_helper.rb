# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require File.expand_path("../../spec/dummy/config/environment.rb",  __FILE__)
require "action_controller"
require "rspec/rails"
require 'ostruct'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.order = :random
  config.use_transactional_fixtures = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end
end
