source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.0.2'

gem 'sass-rails', '5.0.7'
gem 'uglifier', '2.7.1'

gem 'gds-sso', '~> 13.5'
gem 'cancancan', '~> 2.1'
gem 'jquery-ui-rails', '5.0.1'
gem 'plek', '2.1.1'

gem 'formtastic-bootstrap', '3.1.1'
gem 'select2-rails', '3.5.9.3'

gem 'jc-validates_timeliness', '3.1.1'
if ENV['GDS_ZENDESK_DEV']
  gem "gds_zendesk", :path => '../gds_zendesk'
else
  gem "gds_zendesk", '3.0.0'
end
gem 'redis', '3.3.5'
gem "govuk_sidekiq", '~> 2.0'
gem 'kaminari', '~> 0.17.0'
gem 'bootstrap-kaminari-views', '0.0.5'
gem 'govuk_admin_template', '6.5.0'
if ENV['API_DEV']
  gem "gds-api-adapters", :path => '../gds-api-adapters'
else
  gem "gds-api-adapters", '~> 51.2'
end
gem 'gretel', '3.0.9'
gem 'govuk_app_config', '~> 1.3.0'

group :test do
  gem 'shoulda', '~> 3.5.0'
  gem "webmock", "~> 3.3.0"
  gem 'capybara', '~> 2.17'
  gem 'timecop', '~> 0.9.1'
  gem 'rspec-collection_matchers', '~> 1.1.0'
  gem 'factory_girl_rails', '~> 4.9.0'
  gem 'rspec-its', '~> 1.2.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'rspec-rails', '3.5.2'
  gem 'rails-controller-testing'
  gem 'jasmine', '2.9.0'
  gem 'govuk-lint'
  gem 'ci_reporter_rspec'
end
