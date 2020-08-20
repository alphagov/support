require_relative "boot"

require "rails"

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Support
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Enable per-form CSRF tokens.
    config.action_controller.per_form_csrf_tokens = false

    # Enable origin-checking CSRF mitigation.
    config.action_controller.forgery_protection_origin_check = false

    # Make Ruby 2.4 preserve the timezone of the receiver when calling `to_time`.
    ActiveSupport.to_time_preserves_timezone = false

    # Make `form_with` generate non-remote forms.
    config.action_view.form_with_generates_remote_forms = false
  end
end
