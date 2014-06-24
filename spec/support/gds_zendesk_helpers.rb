require 'gds_zendesk/test_helpers'

module ZendeskRequestMockingExtensions
  def expect_zendesk_to_receive_ticket(opts)
    stub_zendesk_ticket_creation_with_body("ticket" => hash_including(opts))
  end
end

RSpec.configure do |c|
  c.include GDSZendesk::TestHelpers
  c.include ZendeskRequestMockingExtensions

  c.before(:context) do
    self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
  end
end
