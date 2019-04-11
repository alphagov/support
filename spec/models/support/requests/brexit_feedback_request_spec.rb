require 'rails_helper'
require 'gds_api/support_api'
require 'gds_api/test_helpers/support_api'

module Support
  module Requests
    include GdsApi::TestHelpers::SupportApi

    describe BrexitFeedbackRequest do
      page_params_one = { "from_date": "2019-01-10", "to_date": "2019-01-10" }
      page_params_two = { "from_date": "2019-01-10", "to_date": "2019-01-10", "page": "2" }
      page_params_three = { "from_date": "2019-01-10", "to_date": "2019-01-10", "page": "3" }

      before { stub_support_api_problem_reports(page_params_one, JSON.parse(File.read('spec/fixtures/response_1.json'))) }
      before { stub_support_api_problem_reports(page_params_two, JSON.parse(File.read('spec/fixtures/response_2.json'))) }
      before { stub_support_api_problem_reports(page_params_three, JSON.parse(File.read('spec/fixtures/response_3.json'))) }

      it "makes the request" do
        feedback_request1 = BrexitFeedbackRequest.new("2019-01-10", "2019-01-10", ["/"])
        expect(feedback_request1.brexity_results.length).to eq(3)
        what_doings = ["doing 1", "doing 2", "doing 3"]
        feedback_request1.brexity_results.each do |res|
          expect(what_doings.include?(res["what_doing"])).to be true
        end
      end

      it "filters non brexit content" do
        feedback_request2 = BrexitFeedbackRequest.new("2019-01-10", "2019-01-10", ["/fake/slug"])
        expect(feedback_request2.brexity_results.length).to eq(0)
      end
    end
  end
end
