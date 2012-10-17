require "zendesk_request"
require "zendesk_client"
require "guard"

class SupportController < ApplicationController

  def amend_content
    if request.method == "GET"
      on_get("Content Change", "content/content_amend_message", "content/amend")
    elsif request.method == "POST"
      @header = "Content Change"
      @header_message = "content/content_amend_message"
      @template = "content/amend"

      @errors = Guard.validationsForAmendContent(params)
      on_post(params, "amend-content")
    end
  end

  def create_user
    if request.method == "GET"
      on_get("Create New User", "useraccess/user_create_message", "useraccess/user")
    elsif request.method == "POST"
      @header = "Create New User"
      @header_message = "useraccess/user_create_message"
      @template = "useraccess/user"

      @errors = Guard.validationsForCreateUser(params)
      on_post(params, "create-user")
    end
  end

  def remove_user
    if request.method == "GET"
      on_get("Remove User", "useraccess/user_remove_message", "useraccess/userremove")
    elsif request.method == "POST"
      @header = "Remove User"
      @header_message = "useraccess/user_remove_message"
      @template = "useraccess/userremove"

      @errors = Guard.validationsForDeleteUser(params)
      on_post(params, "remove-user")
    end
  end

  def campaign
    if request.method == "GET"
      on_get("Campaign", "campaigns/campaign_message", "campaigns/campaign")
    elsif request.method == "POST"
      @header = "Campaign"
      @header_message = "campaigns/campaign_message"
      @template = "campaigns/campaign"

      @errors = Guard.validationsForCampaign(params)
      on_post(params, "campaign")
    end
  end

  def general
    if request.method == "GET"
      on_get("General", "tech-issues/message_general", "tech-issues/general")
    elsif request.method == "POST"
      params[:user_agent] = request.user_agent
      @header = "General"
      @header_message = "tech-issues/message_general"
      @template = "tech-issues/general"

      @errors = Guard.validationsForGeneralIssues(params)
      on_post(params, "general")
    end
  end

  def landing
    render :landing, :layout => "layout"
  end

  def acknowledge
    render :acknowledge, :layout => "layout"
  end

  private

  def on_get(head, head_message_form, template)
    @client = ZendeskClient.get_client(logger)
    @organisations = ZendeskRequest.get_organisations(@client)
    @header = head
    @header_message = head_message_form
    @formdata = {}

    render :"#{template}", :layout => "formlayout"
  end

  def on_post(params, route)
    @client = ZendeskClient.get_client(logger)
    @organisations = ZendeskRequest.get_organisations(@client)
    @formdata = params

    if @errors.empty?
      ticket = ZendeskRequest.raise_zendesk_request(@client, params, route)
      if ticket
        redirect_to '/acknowledge'
      else
        500
      end
    else
      render :"#{@template}", :layout => "formlayout"
    end
  end
end