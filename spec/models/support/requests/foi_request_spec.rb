require "rails_helper"

module Support
  module Requests
    describe FoiRequest do
      it { should validate_presence_of(:requester) }
      it { should allow_value("xyz").for(:details) }
    end
  end
end
