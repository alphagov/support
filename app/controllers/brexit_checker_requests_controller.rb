class BrexitCheckerRequestsController < RequestsController
protected

  def new_request
    @get_ready_for_brexit_checker_request = Support::Requests::BrexitCheckerRequest.new
  end
end
