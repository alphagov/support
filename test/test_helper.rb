ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha_standalone'
require 'webmock/minitest'


class ActiveSupport::TestCase
  def setup
    super
    WebMock.disable_net_connect!
  end
end
