require 'test_helper'

class ZendeskTicketWorkerTest < ActiveSupport::TestCase
  should "raise a ticket successfully" do
    zendesk_has_user(email: "a@b.com", "suspended" => false)

    stub = stub_zendesk_ticket_creation("some" => "options", "requester" => { "email" => "a@b.com" })

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })

    assert_requested(stub)
  end

  should "not raise a ticket if the user is suspended" do
    zendesk_has_user(email: "a@b.com", "suspended" => true)

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })

    assert_not_requested(:post, %r{.*/tickets/.*})
  end
end
