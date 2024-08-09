require "rails_helper"
require "gds_api/test_helpers/support_api"

describe ZendeskTicketWorker do
  it "creates a ticket successfully" do
    stub = stub_support_api_valid_raise_support_ticket("some" => "options", "requester" => { "email" => "a@b.com" }, "comment" => nil)
    ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com" }, "comment" => nil)

    expect(stub).to have_been_made
  end

  it "does not create a ticket when name length exceeds 255 characters" do
    name = "a" * 260
    stub = stub_support_api_valid_raise_support_ticket("some" => "options", "requester" => { "email" => "a@b.com", "name" => name })

    expect {
      ZendeskTicketWorker.new.perform("some" => "options", "requester" => { "email" => "a@b.com", "name" => name })
    }.to raise_error(ZendeskTicketWorker::TicketNameTooLong)
    expect(stub).to_not have_been_made
  end

  it "raises an error if invalid request is made" do
    stub_support_api_invalid_raise_support_ticket(
      "requester" => { "email" => "invalid-email" },
    )

    expect {
      ZendeskTicketWorker.new.perform(
        "requester" => { "email" => "invalid-email" },
      )
    }.to raise_error(GdsApi::HTTPUnprocessableEntity)
  end
end
