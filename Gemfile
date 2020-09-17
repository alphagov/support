source "https://rubygems.org"

gem "rails", "6.0.3.3"

gem "bootstrap-kaminari-views"
gem "cancancan"
gem "fog-aws"
gem "gretel"
gem "jc-validates_timeliness"
gem "jquery-ui-rails"
gem "kaminari"

gem "gds-api-adapters"
gem "gds-sso"
gem "gds_zendesk"
gem "govuk_admin_template"
gem "govuk_app_config"
gem "govuk_sidekiq"
gem "plek"
# Redis is marked as an explicit dependency even though we'd get it
# implicitly from using govuk_sidekiq.  This is because we store user
# objects in it directly as the app has no access to any other database.
gem "redis"
gem "sass-rails"
gem "select2-rails"
gem "uglifier"

group :development do
  gem "listen"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen"
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
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
  gem "timecop"
  gem "webmock"
end
