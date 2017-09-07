require 'rails_helper'

describe ApplicationController, type: :controller do
  # this controller is set up so that the auth always times out
  controller do
    def index
      raise "should never reach this point because authentication should time out"
    end

    private

    def authenticate_user!
      sleep 1
    end

    def default_timeout_in_seconds
      0.5
    end
  end

  it "is unavailable if authentication times out" do
    get :index
    expect(response).to have_http_status(503)
  end
end
