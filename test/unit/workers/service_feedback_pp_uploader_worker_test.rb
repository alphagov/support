require 'test_helper'
require 'date'
require 'gds_api/test_helpers/performance_platform/data_in'

class ServiceFeedbackPPUploaderWorkerTest < ActiveSupport::TestCase
  include Support::Requests::Anonymous
  include GdsApi::TestHelpers::PerformancePlatform::DataIn

  should "push yesterday's stats for each slug to the performance platform" do
    Date.stubs(:yesterday).returns(Date.new(2013,2,10))
    ServiceFeedback.stubs(:transaction_slugs).returns([
      "waste_carrier_or_broker_registration",
      "apply_carers_allowance"
    ])
    ServiceFeedbackAggregatedMetrics.stubs(:new).
      with(Date.new(2013,2,10),"waste_carrier_or_broker_registration").
      returns(stub(to_h: { some: "waste_carrier_data"}))
    ServiceFeedbackAggregatedMetrics.stubs(:new).
      with(Date.new(2013,2,10),"apply_carers_allowance").
      returns(stub(to_h: { some: "carers_allowance_data"}))
    
    stub_post1 = stub_service_feedback_day_aggregate_submission("apply_carers_allowance", { some: "carers_allowance_data"})
    stub_post2 = stub_service_feedback_day_aggregate_submission("waste_carrier_or_broker_registration", { some: "waste_carrier_data"})

    ServiceFeedbackPPUploaderWorker.run

    assert_requested(stub_post1)
    assert_requested(stub_post2)
  end

  should "raise an exception if PP upload returns 404" do
    stub_service_feedback_bucket_unavailable_for("some_slug")

    Date.stubs(:yesterday).returns(Date.new(2013,2,10))
    ServiceFeedback.stubs(:transaction_slugs).returns(["some_slug"])
    ServiceFeedbackAggregatedMetrics.stubs(:new).
      with(Date.new(2013,2,10),"some_slug").
      returns(stub(to_h: { some: "waste_carrier_data"}))

    assert_raises(GdsApi::HTTPNotFound) { ServiceFeedbackPPUploaderWorker.run }
  end
end
