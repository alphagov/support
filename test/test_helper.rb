ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha/api'
require 'webmock/minitest'

require 'ostruct'
require_relative 'test_data'

require 'shoulda/context'
require 'sidekiq/testing/inline'

require 'gds_zendesk/test_helpers'
WebMock.disable_net_connect!

class ActiveSupport::TestCase
  include GDSZendesk::TestHelpers

  def setup
    super
    login_as_stub_user if @user.nil?
    self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
  end

  def login_as_stub_user(options = {})
    defaults = { name: "Stubby McStubby", 
                 email: "stubby@gov.uk",
                 remotely_signed_out?: false,
                 has_permission?: true,
                 can?: true }

    @user = stub("stub user", defaults.merge(options))
    @request.env['warden'] = stub(authenticate!: true, authenticated?: true, user: @user) if @request
  end

  def logout
    @request.env['warden'] = stub(authenticated?: false)
    @request.env['warden'].stubs(:authenticate!).raises(GDS::SSO::ControllerMethods::PermissionDeniedException)
  end
end
