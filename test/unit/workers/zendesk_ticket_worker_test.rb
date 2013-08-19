require 'test_helper'

class ZendeskTicketWorkerTest < ActiveSupport::TestCase
  should "send an email notification if there was an error submitting to Zendesk" do
    zendesk_is_unavailable

    ExceptionNotifier::Notifier.expects(:background_exception_notification)
                         .with(kind_of(ZendeskAPI::Error::ClientError), has_key(:data))
                         .returns(stub("mailer", deliver: true))

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })
  end

  should "not raise a ticket if the user is suspended" do
    zendesk_has_user(email: "a@b.com", "suspended" => true)

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })

    assert_not_requested(:post, %r{.*/tickets/.*})
  end
end
