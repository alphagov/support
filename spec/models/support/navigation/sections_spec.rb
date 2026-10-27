require "rails_helper"

describe Support::Navigation::Sections do
  before { Rails.application.eager_load! }

  it "includes every top level request form" do
    top_level_request_forms = Support::Requests::Request.descendants.select do |request_class|
      request_class.module_parent == Support::Requests
    end

    expect(described_class::ORDERED_INDEX_ITEMS).to include(*top_level_request_forms)
  end
end
