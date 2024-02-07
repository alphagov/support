require "rails_helper"
require "active_model/model"
require "support/gds/with_request_context"

module Support
  module GDS
    class TestModelWithRequestContext
      include ActiveModel::Model
      include WithRequestContext
    end

    describe TestModelWithRequestContext do
      it { should validate_presence_of(:request_context) }
      it { should allow_value("mainstream").for(:request_context) }
      it { should allow_value("detailed_guidance").for(:request_context) }
      it { should_not allow_value("xxx").for(:request_context) }
    end
  end
end
