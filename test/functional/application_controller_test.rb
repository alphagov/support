require 'test_helper'

class TestController < ApplicationController
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

class ApplicationControllerTest < ActionController::TestCase
  setup do
    @controller = TestController.new

    Rails.application.routes.draw do
      match 'index' => "test#index"
    end
  end

  teardown do
    Rails.application.reload_routes!
  end

  should "acknowledge a valid request" do
    get :index
    assert_response 503
  end
end
