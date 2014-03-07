source 'https://rubygems.org'

gem 'rails', '3.2.17'

group :assets do
  gem 'less-rails-bootstrap', '2.1.1'
  gem 'uglifier', '>= 1.0.3'
  gem "therubyracer", "0.12.0"
end

gem 'mysql2', '0.3.14'
gem 'aws-ses', require: 'aws/ses'
gem "exception_notification", '3.0.1'
gem "airbrake", "3.1.15"

gem 'gds-sso', '9.2.0'
gem 'cancan', '1.6.9'
gem 'jquery-rails'
gem 'jquery-ui-rails', '2.0.2'
gem 'plek', '1.7.0'
gem 'formtastic-bootstrap', '2.1.1'
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
gem 'jquery-tablesorter', '1.8.1'
gem 'whenever', '0.9.0', require: false
if ENV['API_DEV']
  gem "gds-api-adapters", :path => '../gds-api-adapters'
else
  gem "gds-api-adapters", "8.3.2"
end

group :development do
  gem "quiet_assets", "1.0.2"
end

group :test do
  gem "mocha", "0.13.3", require: false
  gem "shoulda", "~> 3.3.2"
  gem "webmock", "1.9.0"
  gem 'capybara', '1.1.2'
  gem 'poltergeist', '0.7.0'
  gem 'cucumber-rails', '1.3.0', :require => false
  gem 'timecop', '0.7.1'
end

gem 'unicorn', '4.3.1'
