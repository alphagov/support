require 'spec_helper'
require 'zendesk/ticket/remove_user_request_ticket'

module Zendesk
  module Ticket
    describe RemoveUserRequestTicket do
      subject { RemoveUserRequestTicket.new(double(requester: nil)) }
      its(:tags) { should include("remove_user") }
    end
  end
end
