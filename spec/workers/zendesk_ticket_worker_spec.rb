require 'rails_helper'

describe ZendeskTicketWorker do
  it "raises a ticket successfully" do
    zendesk_has_user(email: "a@b.com", suspended: false)

    stub = stub_zendesk_ticket_creation("some" => "options", "requester" => { "email" => "a@b.com" })

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })

    expect(stub).to have_been_made
  end

  it "doesn't raise a ticket if the user is suspended" do
    zendesk_has_user(email: "a@b.com", suspended: true)

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })

    expect(a_request(:post, %r{.*/tickets/.*})).to_not have_been_made
  end

  it "discards the ticket if it receives a 409 response" do
    zendesk_has_user(email: "a@b.com", suspended: false)

    zendesk_returns_conflict

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })

    expect(a_request(:post, %r{.*/tickets/.*})).to_not have_been_made
  end

  it "raises the ticket if it receives a 503 response" do
    zendesk_has_user(email: "a@b.com", suspended: false)

    zendesk_is_unavailable

    expect{ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })}.to raise_error(ZendeskAPI::Error::NetworkError)
  end

end
