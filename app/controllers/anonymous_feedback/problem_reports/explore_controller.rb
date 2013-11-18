require 'support/requests/anonymous/problem_report'
require 'support/requests/anonymous/explore'

class AnonymousFeedback::ProblemReports::ExploreController < ApplicationController
  authorize_resource class: Support::Requests::Anonymous::ProblemReport

  def new
    @explore = Support::Requests::Anonymous::Explore.new
  end

  def create
    @explore = Support::Requests::Anonymous::Explore.new(params[:support_requests_anonymous_explore])
    if @explore.valid?
      redirect_to anonymous_feedback_problem_reports_url(path: @explore.path)
    else
      render :new, status: 400
    end
  end
end
