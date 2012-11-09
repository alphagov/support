class GeneralRequestsController <  ApplicationController
  def new
    @formdata = {}
    prepopulate_organisation_list
  end

  def create
    params[:user_agent] = request.user_agent
    @template = "general_requests/new"

    @errors = Guard.validationsForGeneralIssues(params)
    on_post(params, "general")
  end
end