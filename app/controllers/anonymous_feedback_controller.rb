class AnonymousFeedbackController < RequestsController
  def set_requester_on(request)
    # this is anonymous feedback, so requester doesn't need to be set
  end
end