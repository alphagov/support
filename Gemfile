source 'https://rubygems.org'

gem 'rails', '3.2.18'

group :assets do
  gem 'sass', '3.2.12'
  gem 'sass-rails', '3.2.6'
  gem 'uglifier', '2.0.1'
end

gem 'mysql2', '0.3.14'
gem "airbrake", "3.1.15"

gem 'gds-sso', '9.2.0'
gem 'cancan', '1.6.9'
gem 'jquery-ui-rails', '4.2.1'
gem 'plek', '1.7.0'
gem 'formtastic-bootstrap', '3.0.0'
gem 'validates_timeliness', '3.0.14'
if ENV['GDS_ZENDESK_DEV']
  gem "gds_zendesk", :path => '../gds_zendesk'
else
  gem "gds_zendesk", '1.0.2'
end
gem 'redis-rails', '3.2.4'
gem "sidekiq", "2.17.1"
gem "statsd-ruby", "1.2.1", require: "statsd"
gem 'logstasher', '0.4.8'
gem 'whenever', '0.9.0', require: false
gem 'kaminari', '0.15.1'
gem 'bootstrap-kaminari-views', '0.0.3'
gem 'govuk_admin_template', '0.1.1'
if ENV['API_DEV']
  gem "gds-api-adapters", :path => '../gds-api-adapters'
else
  gem "gds-api-adapters", "10.8.0"
end

group :development do
  gem "quiet_assets", "1.0.2"
end

group :test do
  gem "mocha", "0.13.3", require: false
  gem 'shoulda', '~> 3.5.0'
  gem "webmock", "1.18.0"
  gem 'capybara', '2.3.0'
  gem 'cucumber-rails', '1.3.0', :require => false
  gem 'timecop', '0.7.1'
  gem 'rspec-collection_matchers', '1.0.0'
  gem 'factory_girl_rails', '4.4.1'
  gem 'rspec-its', '1.0.1'
end

group :development, :test do
  gem 'rspec-rails', '3.0.1'
end

gem 'unicorn', '4.3.1'
