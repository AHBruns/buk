ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"


class ActiveSupport::TestCase
  WebMock.disable_net_connect!(allow_localhost: true)

  parallelize(workers: :number_of_processors)

  fixtures :all
end