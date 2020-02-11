source "https://rubygems.org"

gem "rails", "6.0.2.1"

gem "bootstrap-kaminari-views", "0.0.5"
gem "cancancan", "~> 3.0"
gem "fog-aws", "~> 3.5"
gem "formtastic-bootstrap", "3.1.1"
gem "gretel", "3.0.9"
gem "jc-validates_timeliness", "3.1.1"
gem "jquery-ui-rails", "6.0.1"
gem "kaminari", "~> 1.2.0"
# Redis is marked as an explicit dependency even though we'd get it
# implicitly from using govuk_sidekiq.  This is because we store user
# objects in it directly as the app has no access to any other database.
gem "redis", "4.1.3"
gem "sass-rails", "6.0.0"
gem "select2-rails", "4.0.3"
gem "uglifier", "4.2.0"

# GDS/gov.uk gems
gem "gds-sso", "~> 14.2"
if ENV["GDS_ZENDESK_DEV"]
  gem "gds_zendesk", path: "../gds_zendesk"
else
  gem "gds_zendesk", "3.0.0"
end
gem "govuk_admin_template", "6.7.0"
gem "govuk_app_config", "~> 2.0.3"
if ENV["API_DEV"]
  gem "gds-api-adapters", path: "../gds-api-adapters"
else
  gem "gds-api-adapters", "~> 63.4"
end
gem "govuk_sidekiq", "~> 3.0"
gem "plek", "3.0.0"

group :development do
  gem "listen", ">= 3.0.5", "< 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
end

group :development, :test do
  gem "pry-byebug"
  gem "rails-controller-testing"
  gem "rspec-rails", "4.0.0.beta4"
  gem "rubocop-govuk"
end

group :test do
  gem "factory_bot_rails"
  gem "govuk_test"
  gem "rspec-collection_matchers", "~> 1.2.0"
  gem "rspec-its", "~> 1.3.0"
  gem "shoulda", "~> 3.5.0"
  gem "timecop", "~> 0.9.1"
  gem "webmock", "~> 3.8.1"
end
