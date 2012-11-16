require 'capybara/poltergeist'

Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :browser => :chrome)
end
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 5, debug: true)
end
Capybara.javascript_driver = :poltergeist
