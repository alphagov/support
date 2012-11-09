require "guard"

class SupportController < ApplicationController
  def remove_user
    if request.method == "GET"
      on_get("useraccess/userremove")
    elsif request.method == "POST"
      @template = "useraccess/userremove"

      @errors = Guard.validationsForDeleteUser(params)
      on_post(params, "remove-user")
    end
  end

  def campaign
    if request.method == "GET"
      on_get("campaigns/campaign")
    elsif request.method == "POST"
      @template = "campaigns/campaign"

      @errors = Guard.validationsForCampaign(params)
      on_post(params, "campaign")
    end
  end

  def publish_tool
    if request.method == "GET"
      on_get("tech-issues/publish_tool")
    elsif request.method == "POST"
      params[:user_agent] = request.user_agent
      @template = "tech-issues/publish_tool"

      @errors = Guard.validationsForPublishTool(params)
      on_post(params, "publish-tool")
    end
  end

  def landing
    render :landing, :layout => "application"
  end

  def acknowledge
    render :acknowledge, :layout => "application"
  end
end