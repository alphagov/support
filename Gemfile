source 'https://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

gem 'rails', '3.2.11'

group :assets do
  gem 'less-rails-bootstrap', '2.1.1'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer', '~> 0.9.4'
end

gem 'aws-ses', require: 'aws/ses'
gem 'exception_notification', '~> 2.4.1', require: 'exception_notifier'
gem 'gds-sso', '3.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails', '2.0.2'
gem 'plek', '1.0.0'
gem 'formtastic-bootstrap', '2.0.0'
gem 'validates_timeliness', '3.0.14'
if ENV['GDS_ZENDESK_DEV']
  gem "gds_zendesk", :path => '../gds_zendesk'
else
  gem "gds_zendesk", :git => 'https://github.com/alphagov/gds_zendesk.git', :ref => '0643641afc'
end

group :test do
  gem "mocha", "0.12.6", require: false
  gem "shoulda", "~> 3.3.2"
  gem "webmock", "1.8.11"
  gem 'capybara', '1.1.2'
  gem 'poltergeist', '0.7.0'
  gem 'cucumber-rails', '1.3.0', :require => false
end

gem 'unicorn', '4.3.1'
