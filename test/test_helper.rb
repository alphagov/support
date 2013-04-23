ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha/api'
require 'webmock/minitest'

require 'ostruct'
require_relative 'test_data'

class ActiveSupport::TestCase
  def setup
    super
    WebMock.disable_net_connect!
    login_as_stub_user if @user.nil?
    switch_zendesk_into_dummy_mode
  end

  def login_as_stub_user(options_or_user = {})    
    @user = if options_or_user.is_a?(Hash)
              defaults = { name: "Stubby McStubby", email: "stubby@gov.uk", remotely_signed_out?: false }
              stub("stub user", defaults.merge(options_or_user))
            else
              options_or_user
            end
    @request.env['warden'] = stub(authenticate!: true, authenticated?: true, user: @user)
  end

  def switch_zendesk_into_dummy_mode
    @zendesk_api = GDS_ZENDESK_CLIENT
    @zendesk_api.reset
  end
end

