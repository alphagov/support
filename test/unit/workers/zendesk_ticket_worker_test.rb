require 'test_helper'

class ZendeskTicketWorkerTest < ActiveSupport::TestCase
  should "send an email notification if there was an error submitting to Zendesk" do
    zendesk_is_unavailable

    ExceptionNotifier::Notifier.expects(:background_exception_notification)
                         .with(kind_of(ZendeskAPI::Error::ClientError), has_key(:data))
                         .returns(stub("mailer", deliver: true))

    ZendeskTicketWorker.new.perform(some: "options")
  end
end
