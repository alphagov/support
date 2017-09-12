require 'rails_helper'

module Support
  module Permissions
    describe Ability do
      subject { Ability.new(User.new(permissions: user_permissions)) }

      context "for a user with multiple permissions" do
        let(:user_permissions) { %w[content_requesters campaign_requesters] }

        it { should be_able_to(:create, Support::Requests::CampaignRequest) }
        it { should be_able_to(:create, Support::Requests::LiveCampaignRequest) }
        it { should be_able_to(:create, Support::Requests::ContentChangeRequest) }
      end
    end
  end
end
