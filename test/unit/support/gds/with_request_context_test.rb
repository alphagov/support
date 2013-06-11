require 'test_helper'

require 'active_model/tableless_model'
require 'support/gds/with_request_context'

module Support
  module GDS
    class TestModelWithRequestContext < ActiveModel::TablelessModel
      include WithRequestContext
    end

    class TestModelWithRequestContextTest < Test::Unit::TestCase
      should validate_presence_of(:request_context)
      should allow_value("mainstream").for(:request_context)
      should allow_value("inside_government").for(:request_context)
      should allow_value("detailed_guidance").for(:request_context)
      should_not allow_value("xxx").for(:request_context)

      should "know if it's related to inside government or not" do
        assert TestModelWithRequestContext.new(request_context: "inside_government").inside_government_related?
        assert TestModelWithRequestContext.new(request_context: "detailed_guidance").inside_government_related?
        assert !TestModelWithRequestContext.new(request_context: "mainstream").inside_government_related?
      end

      should "also define the formatted version" do
        assert "Inside Government", TestModelWithRequestContext.new(request_context: "inside_government").formatted_request_context
      end
    end
  end
end