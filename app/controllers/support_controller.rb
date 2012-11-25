require "guard"

class SupportController < RequestsController
  def campaign
    if request.method == "GET"
      on_get("campaigns/campaign")
    elsif request.method == "POST"
      @template = "campaigns/campaign"

      @errors = Guard.validationsForCampaign(params)
      on_post(params, "campaign")
    end
  end

  def landing
    render :landing, :layout => "application"
  end

  def acknowledge
    render :acknowledge, :layout => "application"
  end
end
