require 'guard'

class RemoveUserRequestsController < RequestsController
  def new
    @formdata = {}
    prepopulate_organisation_list
  end

  def create
    @template = "remove_user_requests/new"

    @errors = Guard.validationsForDeleteUser(params)
    on_post(params, "remove-user")
  end
end
