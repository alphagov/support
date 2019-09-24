require "rails_helper"

module Support
  module Requests
    shared_examples_for "a role" do
      let(:requests_anyone_can_make) {
        [
          GeneralRequest,
          TechnicalFaultReport,
          AnalyticsRequest,
        ]
      }

      let(:all_request_types) {
        requests_anyone_can_make + [
          :anonymous_feedback,
          UnpublishContentRequest,
          ContentAdviceRequest,
          CampaignRequest,
          LiveCampaignRequest,
          ContentChangeRequest,
          AccountsPermissionsAndTrainingRequest,
          FoiRequest,
          NamedContact,
          ChangesToPublishingAppsRequest,
          RemoveUserRequest,
        ]
      }

      let(:allowed_request_types) { requests_anyone_can_make + requests_specific_to_role }
      let(:disallowed_request_types) { all_request_types - allowed_request_types }

      it "can make certain request types" do
        allowed_request_types.each do |request_class|
          expect(subject).to be_able_to(:create, request_class)
        end
      end

      it "cannot make certain request types" do
        disallowed_request_types.each do |request_class|
          expect(subject).to_not be_able_to(:create, request_class)
        end
      end
    end

    describe "permissions" do
      context "for normal users" do
        subject { create(:user) }
        let(:requests_specific_to_role) { [] }
        it_behaves_like "a role"
      end

      context "for content requesters" do
        subject { create(:content_requester) }
        let(:requests_specific_to_role) { [ChangesToPublishingAppsRequest, ContentChangeRequest, ContentAdviceRequest, UnpublishContentRequest, AnalyticsRequest] }
        it_behaves_like "a role"
      end

      context "for user managers" do
        subject { create(:user_manager) }
        let(:requests_specific_to_role) { [AccountsPermissionsAndTrainingRequest, RemoveUserRequest, AnalyticsRequest] }
        it_behaves_like "a role"
      end

      context "for campaign requesters" do
        subject { create(:campaign_requester) }
        let(:requests_specific_to_role) { [CampaignRequest, LiveCampaignRequest] }
        it_behaves_like "a role"
      end

      context "for API users" do
        subject { create(:api_user) }
        let(:requests_specific_to_role) { [FoiRequest, NamedContact] }
        it_behaves_like "a role"
      end

      context "for single points of contact" do
        subject { create(:single_point_of_contact) }
        let(:requests_specific_to_role) {
          [
            :anonymous_feedback,
            UnpublishContentRequest,
            ContentAdviceRequest,
            AnalyticsRequest,
            CampaignRequest,
            LiveCampaignRequest,
            ContentChangeRequest,
            AccountsPermissionsAndTrainingRequest,
            FoiRequest,
            NamedContact,
            ChangesToPublishingAppsRequest,
            RemoveUserRequest,
          ]
        }
        it_behaves_like "a role"
      end
    end
  end
end
