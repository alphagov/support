require "rails_helper"

describe Support::Navigation::Sections do
  before { Rails.application.eager_load! }

  it "includes every top level request form" do
    top_level_request_forms = Support::Requests::Request.descendants.select do |request_class|
      request_class.module_parent == Support::Requests
    end

    top_level_request_forms.all? { |required_class| described_class::ORDERED_INDEX_ITEMS.include? required_class }
  end
end
