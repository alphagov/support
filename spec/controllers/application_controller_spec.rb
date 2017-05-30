require 'rails_helper'

describe ApplicationController, :type => :controller do
  context 'authentication time out' do
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

  context 'signin permissions' do
    controller do
      def index
        head :ok
      end
    end

    it 'rejects users without signin permission' do
      login_as create(:user, permissions: [])
      get :index
      expect(response).to have_http_status(403)
    end

    it 'allows users with signin permission' do
      login_as create(:user, permissions: ['signin'])
      get :index
      expect(response).to have_http_status(200)
    end
  end
end
