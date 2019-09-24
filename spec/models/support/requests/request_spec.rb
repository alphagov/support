require "rails_helper"

module Support
  module Requests
    describe Request do
      it "be initialized with a requester" do
        expect(Request.new.requester).to_not be_nil
      end
    end
  end
end
