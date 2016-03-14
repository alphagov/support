require 'rails_helper'

describe ZendeskTicketWorker do
  it "raises a ticket successfully" do
    zendesk_has_user(email: "a@b.com", "suspended" => false)

    stub = stub_zendesk_ticket_creation("some" => "options", "requester" => { "email" => "a@b.com" })

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })

    expect(stub).to have_been_made
  end

  it "doesn't raise a ticket if the user is suspended" do
    zendesk_has_user(email: "a@b.com", "suspended" => true)

    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" })

    expect(a_request(:post, %r{.*/tickets/.*})).to_not have_been_made
  end
end
