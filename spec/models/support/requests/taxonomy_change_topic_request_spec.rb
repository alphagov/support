require 'spec_helper'
require 'support/requests/taxonomy_change_topic_request'

module Support
  module Requests
    describe TaxonomyChangeTopicRequest do
      def request(options = {})
        TaxonomyChangeTopicRequest.new(options).tap(&:valid?)
      end

      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:details) }
      it { should validate_presence_of(:reasons) }

      it { should allow_value("XXX").for(:title) }

      it { should allow_value("name_of_topic").for(:type_of_change) }
      it { should allow_value("position_of_topic").for(:type_of_change) }
      it { should allow_value("merge_split_topic").for(:type_of_change) }
      it { should allow_value("remove_topic").for(:type_of_change) }
      it { should allow_value("other").for(:type_of_change) }
      it { should_not allow_value("xxx").for(:type_of_change) }

      it "provides type of change choices" do
        expect(request.type_of_change_options).to_not be_empty
      end

      it "provides formatted type of change" do
        expect(request(type_of_change: "name_of_topic").formatted_type_of_change).to eq("Name of topic")
      end
    end
  end
end
