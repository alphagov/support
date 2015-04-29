source 'https://rubygems.org'

gem 'rails', '4.2.1'

gem 'sass-rails', '5.0.3'
gem 'uglifier', '2.7.1'

gem 'mysql2', '0.3.14'
gem "airbrake", "3.1.15"

gem 'gds-sso', '9.4.0'
gem 'cancan', '1.6.10'
gem 'jquery-ui-rails', '5.0.1'
gem 'plek', '1.10.0'
gem 'formtastic-bootstrap', '3.1.0'
gem 'jc-validates_timeliness', '3.1.1'
if ENV['GDS_ZENDESK_DEV']
  gem "gds_zendesk", :path => '../gds_zendesk'
else
  gem "gds_zendesk", '1.0.4'
end
gem 'redis', '3.0.6'
gem "sidekiq", "2.17.1"
gem "statsd-ruby", "1.2.1", require: "statsd"
gem 'logstasher', '0.4.8'
gem 'whenever', '0.9.4', require: false
gem 'kaminari', '0.15.1'
gem 'bootstrap-kaminari-views', '0.0.5'
gem 'govuk_admin_template', '2.2.0'
if ENV['API_DEV']
  gem "gds-api-adapters", :path => '../gds-api-adapters'
else
  gem "gds-api-adapters", "10.8.0"
end
gem 'jbuilder', '2.2.13'
gem 'gretel', '3.0.8'

group :development do
  gem "quiet_assets", "~> 1.1.0"
end

group :test do
  gem 'shoulda', '~> 3.5.0'
  gem "webmock", "~> 1.21.0"
  gem 'capybara', '~> 2.4.0'
  gem 'timecop', '~> 0.7.1'
  gem 'rspec-collection_matchers', '~> 1.1.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'rspec-its', '~> 1.2.0'
end

group :development, :test do
  gem 'rspec-rails', '3.2.1'
end

gem 'unicorn', '4.9.0'
