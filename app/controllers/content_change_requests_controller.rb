require 'guard'

class ContentChangeRequestsController < ApplicationController
  def new
    @formdata = {}
    prepopulate_organisation_list
  end

  def create
    @template = "content_change_requests/new"

    @errors = Guard.validationsForAmendContent(params)
    on_post(params, "amend-content")
  end
end
