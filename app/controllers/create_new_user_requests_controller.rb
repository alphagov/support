class CreateNewUserRequestsController < ApplicationController
  def new
    @formdata = {}
    prepopulate_organisation_list
  end

  def create
    @template = "create_new_user_requests/new"

    @errors = Guard.validationsForCreateUser(params)
    on_post(params, "create-user")
  end
end
