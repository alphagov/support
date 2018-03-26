source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.1.5'

gem 'bootstrap-kaminari-views', '0.0.5'
gem 'cancancan', '~> 2.1'
gem 'formtastic-bootstrap', '3.1.1'
gem 'gretel', '3.0.9'
gem 'jc-validates_timeliness', '3.1.1'
gem 'jquery-ui-rails', '6.0.1'
gem 'kaminari', '~> 1.1.1'
# Redis is marked as an explicit dependency even though we'd get it
# implicitly from using govuk_sidekiq.  This is because we store user
# objects in it directly as the app has no access to any other database.
gem 'redis', '4.0.1'
gem 'sass-rails', '5.0.7'
gem 'select2-rails', '4.0.3'
gem 'uglifier', '4.1.8'

# GDS/gov.uk gems
gem 'gds-sso', '~> 13.6'
if ENV['GDS_ZENDESK_DEV']
  gem 'gds_zendesk', :path => '../gds_zendesk'
else
  gem 'gds_zendesk', '3.0.0'
end
gem 'govuk_admin_template', '6.5.0'
gem 'govuk_app_config', '~> 1.4.1'
if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '~> 52.4'
end
gem 'govuk_sidekiq', '~> 3.0'
gem 'plek', '2.1.1'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'govuk-lint'
  gem 'jasmine', '3.1.0'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '3.7.2'
end

group :test do
  gem 'capybara', '~> 2.18'
  gem 'factory_bot_rails'
  gem 'rspec-collection_matchers', '~> 1.1.0'
  gem 'rspec-its', '~> 1.2.0'
  gem 'shoulda', '~> 3.5.0'
  gem 'timecop', '~> 0.9.1'
  gem 'webmock', '~> 3.3.0'
end
