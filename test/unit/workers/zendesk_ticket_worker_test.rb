require 'test_helper'

class ZendeskTicketWorkerTest < Test::Unit::TestCase
  should "send an email notification if there was an error submitting to Zendesk" do
    GDS_ZENDESK_CLIENT.ticket.should_raise_error
    ExceptionNotifier::Notifier.expects(:background_exception_notification)
                         .with(kind_of(ZendeskAPI::Error::ClientError), has_key(:data))
                         .returns(stub("mailer", deliver: true))

    ZendeskTicketWorker.new.perform(some: "options")
  end

  def teardown
    GDS_ZENDESK_CLIENT.reset
  end
end
