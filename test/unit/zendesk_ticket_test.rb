require 'test/unit'
require 'shoulda/context'
require 'zendesk_ticket'
require 'test_data'

class ZendeskTicketTest < Test::Unit::TestCase
  def new_ticket(type = nil)
    ZendeskTicket.new(valid_content_change_request_params, type)
  end

  include TestData
  context "content change request" do
    setup do
      @ticket = new_ticket
    end

    should "set the tags correctly for content change requests" do
      assert_equal ['content_amend'], new_ticket('amend-content').tags
    end

    should "set the tags correctly for valid inside govt tickets" do
      ticket = ZendeskTicket.new(valid_content_change_request_params.merge(:inside_government => "yes"), "amend-content")
      assert_equal ['content_amend', 'inside_government'], ticket.tags
    end

    should "set the requester details correctly" do
      assert_equal valid_content_change_request_params[:name], @ticket.name
      assert_equal valid_content_change_request_params[:email], @ticket.email
      assert_equal valid_content_change_request_params[:organisation], @ticket.organisation
      assert_equal valid_content_change_request_params[:job], @ticket.job
      assert_equal valid_content_change_request_params[:phone], @ticket.phone
    end

    should "concatenate the need_by_date correctly" do
      params = valid_content_change_request_params.merge(:need_by_day => "01", :need_by_month => "02", :need_by_year => "2012")
      ticket = ZendeskTicket.new(params, "amend-content")
      assert_equal "01/02/2012", ticket.need_by_date
    end

    should "concatenate the not_before_date correctly" do
      params = valid_content_change_request_params.merge(:not_before_day => "01", :not_before_month => "02", :not_before_year => "2012")
      ticket = ZendeskTicket.new(params, "amend-content")
      assert_equal "01/02/2012", ticket.not_before_date
    end

    should "set the subject according to request type" do
      assert_equal "Content change request", new_ticket("amend-content").subject
      assert_equal "Create new user", new_ticket("create-user").subject
      assert_equal "Remove user", new_ticket("remove-user").subject
      assert_equal "Campaign", new_ticket("campaign").subject
      assert_equal "Publishing Tool", new_ticket("publish-tool").subject
    end

    should "remove spaces from the tel number" do
      params = valid_content_change_request_params.merge(:phone => "1234 5678")
      ticket = ZendeskTicket.new(params, "amend-content")
      assert_equal "12345678", ticket.phone
    end
  end
end