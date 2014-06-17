require 'rails_helper'
require 'time'
require 'json'
require 'deduplication_worker'

describe "de-duplication" do
  before do
    login_as create(:feedex_user)
  end

  it "flags and removes duplicate service feedback from results" do
    Timecop.travel Time.parse("2013-01-15 12:00:00")

    create(:service_feedback,
      service_satisfaction_rating: 5,
      details: "this service is great",
      slug: "some-tx",
      url: "https://www.gov.uk/done/some-tx"
    )

    create(:service_feedback,
      service_satisfaction_rating: 3,
      details: "this service is meh",
      slug: "some-tx",
      url: "https://www.gov.uk/done/some-tx"
    )

    Timecop.travel Time.parse("2013-01-15 12:00:01")

    create(:service_feedback,
      service_satisfaction_rating: 3,
      details: "this service is meh",
      slug: "some-tx",
      url: "https://www.gov.uk/done/some-tx"
    )

    get '/anonymous_feedback?path=/done/some-tx', "", {"CONTENT_TYPE" => 'application/json', 'HTTP_ACCEPT' => 'application/json'}

    expect(json_response).to have(3).items

    # deduplicate
    Timecop.travel Time.parse("2013-01-16 00:30:00")
    DeduplicationWorker.run

    # rerun query, one piece of feedback should now be suppressed
    get '/anonymous_feedback?path=/done/some-tx', "", {"CONTENT_TYPE" => 'application/json', 'HTTP_ACCEPT' => 'application/json'}

    expect(json_response).to have(2).items
    expect(json_response.map {|r| r["details"]}.sort).to eq(["this service is great", "this service is meh"])
  end

  def teardown
    Timecop.return
  end
end
