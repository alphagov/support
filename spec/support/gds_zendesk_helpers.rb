require 'gds_zendesk/test_helpers'

RSpec.configure do |c|
  c.include GDSZendesk::TestHelpers

  c.before(:context) do
    self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
  end
end
