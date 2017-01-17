require 'spec_helper'
require 'support/requests/taxonomy_new_topic_request'

module Support
  module Requests
    describe TaxonomyNewTopicRequest do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:url) }
      it { should validate_presence_of(:details) }
      it { should validate_presence_of(:parent) }

      it { should allow_value("XXX").for(:title) }
    end
  end
end
