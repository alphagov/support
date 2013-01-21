ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha_standalone'
require 'webmock/minitest'

require 'ostruct'
require_relative 'test_data'

class ActiveSupport::TestCase
  def setup
    super
    WebMock.disable_net_connect!
    login_as_stub_user
    switch_zendesk_into_dummy_mode
  end

  def login_as_stub_user
    @user = stub("stub user",
                  name: "Stubby McStubby", remotely_signed_out?: false)
    request.env['warden'] = stub(:authenticate! => true, :authenticated? => true, :user => @user)
  end

  def switch_zendesk_into_dummy_mode
    @zendesk_api = GDS_ZENDESK_CLIENT
  end
end

