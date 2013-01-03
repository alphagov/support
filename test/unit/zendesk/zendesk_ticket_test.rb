require 'test/unit'
require 'shoulda/context'
require 'zendesk_ticket'
require 'ostruct'
require 'date'

class ExampleZendeskTicketSubclass < ZendeskTicket
  def request_specific_tags
    ["some_tag"]
  end
end

class ZendeskTicketTest < Test::Unit::TestCase
  def new_ticket(attributes)
    ZendeskTicket.new(OpenStruct.new(attributes))
  end

  def with_requester(attributes)
    {requester: OpenStruct.new(attributes)}
  end

  def with_time_constraint(attributes)
    {time_constraint: OpenStruct.new(attributes)}
  end

  def with_a_valid_requester
    with_requester(email: "ab@c.com")
  end

  context "any request" do
    should "set the requester details correctly" do
      ticket = new_ticket(with_requester(email: "ab@c.com", name: "A B"))
      assert_equal "ab@c.com", ticket.email
      assert_equal "A B", ticket.name
    end

    should "have the request-specific tags as defined on the subclass" do
      ticket = new_ticket(with_a_valid_requester)
      assert_includes ticket.tags, "govt_form"
    end

    context "with time constraints" do
      should "pass the need_by_date through" do
        assert_equal "03-02-2001", 
                     new_ticket(with_time_constraint(needed_by_date: "03-02-2001")).needed_by_date
      end

      should "pass the not_before_date through" do
        assert_equal "03-02-2001", 
                     new_ticket(with_time_constraint(not_before_date: "03-02-2001")).not_before_date
      end
    end

    context "with collaborators set" do
      should "be passed through" do
        ticket = new_ticket(with_requester(collaborator_emails: ["ab@c.com", "de@f.com"]))
        assert_equal ["ab@c.com", "de@f.com"], ticket.collaborator_emails
      end
    end
  end
end