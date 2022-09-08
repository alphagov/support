require "rails_helper"

describe ZendeskTicketWorker do
  context "normal ticket creation" do
    before do
      zendesk_has_user(email: "a@b.com", suspended: false)
    end

    it "creates a ticket successfully" do
      stub = stub_zendesk_ticket_creation("some" => "options", "requester" => { "email" => "a@b.com" }, "comment" => nil)
      ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })

      expect(stub).to have_been_made
    end
  end

  context "ticket creation when name length exceeds 255 characters" do
    before do
      zendesk_has_user(email: "a@b.com", suspended: false)
    end

    it "does not create a ticket" do
      name = "a" * 260
      stub = stub_zendesk_ticket_creation("some" => "options", "requester" => { "email" => "a@b.com", "name" => name })
      ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com", "name" => name })

      expect(stub).to_not have_been_made
    end
  end

  context "with a suspended requesting user" do
    before do
      zendesk_has_user(email: "a@b.com", suspended: true)
      ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })
    end

    it "does not create a ticket" do
      expect(a_request(:post, %r{.*/tickets/.*})).to_not have_been_made
    end
  end

  context "with a 409 response" do
    before do
      zendesk_has_user(email: "a@b.com", suspended: false)
      zendesk_returns_conflict
      ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })
    end

    it "discards the ticket" do
      expect(a_request(:post, %r{.*/tickets/.*})).to_not have_been_made
    end
  end

  context "with a 503 response" do
    before do
      zendesk_has_user(email: "a@b.com", suspended: false)
      zendesk_is_unavailable
    end

    it "raises the error" do
      expect { ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" }) }.to raise_error(ZendeskAPI::Error::NetworkError)
    end
  end

  context "with a 302 response" do
    before do
      zendesk_has_user(email: "a@b.com", suspended: false)
      zendesk_returns_redirect
    end

    it "raises the error" do
      expect { ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" }) }.to raise_error(ZendeskAPI::Error::NetworkError)
    end
  end
end
