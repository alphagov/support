class WhitehallAccountsPermissionsAndTrainingRequestsController < RequestsController
protected

  def new_request
    redirect_to whitehall_signup_form_url
  end

private

  def whitehall_signup_form_url
    "https://docs.google.com/forms/d/e/1FAIpQLSfejhUERzSzYKhdGBVE8Ktf1s2UCa1FHD-IvABQVFqsBqVfPw/viewform"
  end
end
