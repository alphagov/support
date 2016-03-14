source 'https://rubygems.org'

gem 'rails', '4.2.5.1'

gem 'sass-rails', '5.0.3'
gem 'uglifier', '2.7.1'

gem "airbrake", "4.1.0"

gem 'gds-sso', '11.2.0'
gem 'cancan', '1.6.10'
gem 'jquery-ui-rails', '5.0.1'
gem 'plek', '1.10.0'

# using github version to pick up unreleased bugfix
# https://github.com/mjbellantoni/formtastic-bootstrap/pull/119
gem 'formtastic-bootstrap', github: 'mjbellantoni/formtastic-bootstrap', ref: '8134e3f'
gem 'select2-rails', '3.5.9.3'

gem 'jc-validates_timeliness', '3.1.1'
if ENV['GDS_ZENDESK_DEV']
  gem "gds_zendesk", :path => '../gds_zendesk'
else
  gem "gds_zendesk", '2.1.0'
end
gem 'redis', '3.2.1'
gem "sidekiq", "3.3.4"
gem "sidekiq-statsd", "0.1.5"
gem "statsd-ruby", "1.2.1", require: "statsd"
gem 'logstasher', '0.4.8'
gem 'kaminari', '0.16.3'
gem 'bootstrap-kaminari-views', '0.0.5'
gem 'govuk_admin_template', '3.0.0'
if ENV['API_DEV']
  gem "gds-api-adapters", :path => '../gds-api-adapters'
else
  gem "gds-api-adapters", '20.1.1'
end
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
  gem 'pry-byebug'
  gem 'rspec-rails', '3.3.3'
  gem 'jasmine', '2.3.0'
end

gem 'unicorn', '4.9.0'
