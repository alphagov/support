require 'spec_helper'

module Zendesk
  module Ticket
    describe RemoveUserRequestTicket do
      subject { RemoveUserRequestTicket.new(double(requester: nil)) }
      its(:tags) { should include("remove_user") }
    end
  end
end
