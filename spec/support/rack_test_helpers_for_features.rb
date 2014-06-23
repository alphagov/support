# Capybara doesn't allow access to raw gets/posts/responses directly,
# but testing through the REST API is a legitimate usecase within end-to-end specs
module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :feature
end
