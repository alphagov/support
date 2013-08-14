require 'test_helper'

class ZendeskTicketWorkerTest < Test::Unit::TestCase
  should "send an email notification if there was an error submitting to Zendesk" do
    GDS_ZENDESK_CLIENT.ticket.should_raise_error
    ExceptionNotifier::Notifier.expects(:background_exception_notification)
                         .with(kind_of(ZendeskAPI::Error::ClientError), has_key(:data))
                         .returns(stub("mailer", deliver: true))

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })
  end

  should "not raise a ticket if the user is suspended" do
    GDS_ZENDESK_CLIENT.users.should_be_suspended

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })
    refute GDS_ZENDESK_CLIENT.ticket.raised?
  end

  def teardown
    GDS_ZENDESK_CLIENT.reset
  end
end
