require 'test_helper'
require 'zendesk_users'

class ZendeskUsersTest < Test::Unit::TestCase
  def setup
    @stub_zendesk_users = stub("zendesk API")
    client = stub("Zendesk client", users: @stub_zendesk_users)
    @users = ZendeskUsers.new(client)
  end

  context "creating/updating a user that already exists in Zendesk" do
    should "update the phone and job title if those are set" do
      stub_existing_zendesk_user = stub("existing zendesk user")
      @stub_zendesk_users.expects(:search).with(query: "test@test.com").returns([stub_existing_zendesk_user])
      stub_existing_zendesk_user.expects(:update).with(details: "Job title: Developer")
      stub_existing_zendesk_user.expects(:update).with(phone: "12345")
      stub_existing_zendesk_user.expects(:save)

      existing_user_being_requested = stub("requested user", email: "test@test.com", phone: "12345", job: "Developer")
      @users.create_or_update_user(existing_user_being_requested)
    end
  end

  context "creating/updating a user that doesn't exists in Zendesk" do
    should "create that user" do
      @stub_zendesk_users.expects(:search).with(query: "test@test.com").returns([])
      @stub_zendesk_users.expects(:create).with(email:    "test@test.com",
                                                name:     "Abc",
                                                phone:    "12345",
                                                details:  "Job title: Developer",
                                                verified: true)

      existing_user_being_requested = stub("requested user", name: "Abc", email: "test@test.com", phone: "12345", job: "Developer")
      @users.create_or_update_user(existing_user_being_requested)
    end
  end
end