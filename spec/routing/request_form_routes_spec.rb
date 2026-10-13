require "rails_helper"

describe "request form routes" do
  before { Rails.application.eager_load! }

  it "draws a route for every request form" do
    expected = Support::Requests::Request.descendants.map do |request_class|
      name = request_class.name.delete_prefix("Support::Requests::").underscore.tr("/", "_")

      "new_#{name}"
    end
    drawn = Rails.application.routes.routes.map(&:name).compact.grep(/\Anew_/)

    expect(drawn).to match_array(expected)
  end
end
