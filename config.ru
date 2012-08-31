require "./lib/app"
if ENV['RACK_ENV'] == "development"
  use(Slimmer::App, :asset_host => "http://static.preview.alphagov.co.uk")
else
  use Slimmer::App
end
run App