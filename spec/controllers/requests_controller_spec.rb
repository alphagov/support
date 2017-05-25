require 'rails_helper'
require 'active_model/model'

describe RequestsController, :type => :controller do
  class TestRequest
    include ActiveModel::Model
    include Support::Requests::WithRequester

    attr_accessor :a, :b
    validates_presence_of :a
  end

  class TestZendeskTicket < Zendesk::ZendeskTicket
    def subject
      "Test request"
    end

    def tags
      ["tag_a", "tag_b"]
    end

    def comment_snippets
      []
    end
  end

  controller do
    def new_request
      TestRequest.new(requester: Support::Requests::Requester.new)
    end

    def zendesk_ticket_class
      TestZendeskTicket
    end

    def parse_request_from_params
      TestRequest.new(params.require(:test_request).permit!.to_h)
    end
  end

  def valid_params_for_test_request
    {
      "test_request" => {
        "a" => "A string", "b" => "Another string",
        "requester_attributes" => {"email" => "abc@d.com"}
      }
    }
  end

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    allow(controller).to receive(:default_render)
  end

  before do
    login_as user
    zendesk_has_no_user_with_email(user.email)

    prevent_implicit_rendering
  end

  context "for an authorised user" do
    let(:user) { create(:user_who_can_access_everything) }

    it "renders a new form" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "rejects form submissions with invalid parameters" do
      params = valid_params_for_test_request.tap {|p| p["test_request"].merge!("a" => "")}
      expect(controller).to receive(:render).with(:new, hash_including(status: 400))

      post :create, params: params
    end

    it "submits it to Zendesk" do
      ticket_request = stub_zendesk_ticket_creation(hash_including("tags" => ['tag_a', 'tag_b']))

      post :create, params: valid_params_for_test_request

      expect(response).to redirect_to("/acknowledge")
      expect(ticket_request).to have_been_made
    end

    it "reads the signed-in user's details as the requester" do
      requester_details = { "email" => @user[:email], "name" => @user[:name] }
      ticket_request = stub_zendesk_ticket_creation(
        hash_including("requester" => hash_including(requester_details))
      )

      post :create, params: valid_params_for_test_request

      expect(ticket_request).to have_been_made
    end

    it "set collaborators if they're set on the request" do
      params = valid_params_for_test_request.tap do |p|
        p["test_request"]["requester_attributes"].merge!("collaborator_emails" => "ab@c.com, def@g.com")
      end
      ticket_request = stub_zendesk_ticket_creation(hash_including("collaborators" => ["ab@c.com", "def@g.com"]))

      post :create, params: params

      expect(ticket_request).to have_been_made
    end
  end

  context "for an unauthorised user" do
    let(:user) { create(:user_who_cannot_access_anything) }

    it "rejects an text/html request for a new form" do
      expect(controller).to receive(:render).with("support/forbidden", hash_including(status: 403))
      get :new
    end

    it "rejects a json request for a new form" do
      expect(controller).to receive(:render).with(json: {"error" => "You have not been granted permission to make these requests."}, status: 403)
      get :new, params: { format: :json }
    end

    it "rejects a form submission" do
      expect(controller).to receive(:render).with("support/forbidden", hash_including(status: 403))
      post :create, params: valid_params_for_test_request
    end
  end
end
