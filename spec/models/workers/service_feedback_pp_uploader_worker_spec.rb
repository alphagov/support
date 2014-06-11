require 'rails_helper'
require 'date'
require 'gds_api/test_helpers/performance_platform/data_in'

describe ServiceFeedbackPPUploaderWorker do
  include GdsApi::TestHelpers::PerformancePlatform::DataIn

  it "pushes yesterday's stats for each slug to the performance platform" do
    Timecop.travel Date.new(2013,2,11)

    create(:service_feedback, slug: "waste_carrier_or_broker_registration", created_at: Date.yesterday)
    create(:service_feedback, slug: "apply_carers_allowance", created_at: Date.yesterday)

    stub_post1 = stub_service_feedback_day_aggregate_submission("apply_carers_allowance")
    stub_post2 = stub_service_feedback_day_aggregate_submission("waste_carrier_or_broker_registration")

    ServiceFeedbackPPUploaderWorker.run

    expect(stub_post1).to have_been_made
    expect(stub_post2).to have_been_made
  end
end
