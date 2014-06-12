require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  class ControllerWhichTimesOutDuringAuthentication < ApplicationController
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

  before do
    @controller = ControllerWhichTimesOutDuringAuthentication.new

    Rails.application.routes.draw do
      match 'index' => "controller_which_times_out_during_authentication#index"
    end
  end

  after do
    Rails.application.reload_routes!
  end

  it "is unavailable if authentication times out" do
    get :index
    expect(response).to have_http_status(503)
  end
end
