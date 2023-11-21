source "https://rubygems.org"

gem "rails", "7.1.2"

gem "bootsnap", require: false
gem "bootstrap-kaminari-views"
gem "cancancan"
gem "fog-aws"
gem "gds-api-adapters"
gem "gds-sso"
gem "gds_zendesk"
gem "govuk_admin_template"
gem "govuk_app_config"
gem "govuk_sidekiq"
gem "gretel"
gem "jquery-ui-rails", github: "jquery-ui-rails/jquery-ui-rails", tag: "v7.0.0" # https://github.com/jquery-ui-rails/jquery-ui-rails/pull/139#issuecomment-1768150544
gem "kaminari"
gem "plek"
gem "redis"
gem "sassc-rails"
gem "select2-rails"
gem "sentry-sidekiq"
gem "sprockets-rails"
gem "uglifier"
gem "validates_timeliness", "~> 7.0.0.beta2"

group :development do
  gem "listen"
  gem "spring"
  gem "web-console"
end

group :development, :test do
  gem "pry-byebug"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "rubocop-govuk"
end

group :test do
  gem "factory_bot_rails"
  gem "govuk_test"
  gem "rspec-collection_matchers"
  gem "rspec-its"
  gem "shoulda"
  gem "simplecov"
  gem "timecop"
  gem "webmock"
end
