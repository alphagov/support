require 'test/unit'
require 'shoulda/context'
require 'zendesk_ticket'
require 'test_data'
require 'ostruct'

class ZendeskTicketTest < Test::Unit::TestCase
  def new_ticket(attributes, type = nil)
    ZendeskTicket.new(OpenStruct.new(attributes), type)
  end

  include TestData
  context "content change request" do
    should "set the tags correctly for content change requests" do
      assert_equal ['content_amend'], new_ticket({}, 'amend-content').tags
    end

    should "set the tags correctly for valid inside govt tickets" do
      assert_includes new_ticket(:inside_government => "yes").tags, 'inside_government'
    end

    should "set the requester details correctly" do
      ticket = new_ticket(
        :name => "John Smith",
        :email => "ab@c.com",
        :organisation => "cabinet_office",
        :job => "Developer",
        :phone => "123456"
      )
      assert_equal "John Smith", ticket.name
      assert_equal "ab@c.com", ticket.email
      assert_equal "cabinet_office", ticket.organisation
      assert_equal "Developer", ticket.job
      assert_equal "123456", ticket.phone
    end

    should "concatenate the need_by_date correctly" do
      options = {need_by_day: "01", need_by_month: "02", need_by_year: "2012"}
      assert_equal "01/02/2012", new_ticket(options).need_by_date
    end

    should "concatenate the not_before_date correctly" do
      options = {not_before_day: "01", not_before_month: "02", not_before_year: "2012"}
      assert_equal "01/02/2012", new_ticket(options).not_before_date
    end

    should "set the subject according to request type" do
      assert_equal "Content change request", new_ticket({}, "amend-content").subject
      assert_equal "Create new user", new_ticket({}, "create-user").subject
      assert_equal "Remove user", new_ticket({}, "remove-user").subject
      assert_equal "Campaign", new_ticket({}, "campaign").subject
      assert_equal "Publishing Tool", new_ticket({}, "publish-tool").subject
    end

    should "remove spaces from the tel number" do
      assert_equal "12345678", new_ticket(:phone => "1234 5678").phone
    end
  end
end