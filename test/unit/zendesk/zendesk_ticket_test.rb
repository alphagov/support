require 'test/unit'
require 'shoulda/context'
require 'zendesk_ticket'
require 'ostruct'
require 'date'

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

  context "content change request" do
    should "set the requester details correctly" do
      ticket = new_ticket(with_requester(email: "ab@c.com"))
      assert_equal "ab@c.com", ticket.email
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
  end
end