require 'rails_helper'
require 'ostruct'
require 'date'

describe Zendesk::ZendeskTicket do
  def new_ticket(attributes)
    attributes ||= { requester: OpenStruct.new(email: "ab@c.com") }
    Zendesk::ZendeskTicket.new(OpenStruct.new(attributes))
  end

  def with_requester(attributes)
    { requester: OpenStruct.new(attributes) }
  end

  def with_time_constraint(attributes)
    { time_constraint: OpenStruct.new(attributes) }
  end

  subject { new_ticket(with_requester(name: "A B", email: "ab@c.com")) }

  its(:email) { should eq("ab@c.com") }
  its(:tags) { should include("govt_form") }
  its(:priority) { should eq("normal") }
  its(:to_s) { should include("ab@c.com", "A B") }

  context "with time constraints" do
    subject { new_ticket(with_time_constraint(needed_by_date: "03-02-2001", not_before_date: "03-02-2001")) }
    its(:needed_by_date) { should eq("03-02-2001") }
    its(:not_before_date) { should eq("03-02-2001") }
  end

  context "with collaborators" do
    subject { new_ticket(with_requester(collaborator_emails: ["ab@c.com", "de@f.com"])) }
    its(:collaborator_emails) { should eq(["ab@c.com", "de@f.com"]) }
    its(:to_s) { should include("ab@c.com\nde@f.com") }
  end
end
