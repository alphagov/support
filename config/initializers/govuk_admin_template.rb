GovukAdminTemplate.configure do |c|
  c.app_title = "GOV.UK Support"
  c.show_signout = true
end

GovukAdminTemplate.environment_label = ENV.fetch("GOVUK_ENVIRONMENT_NAME", "development").titleize
GovukAdminTemplate.environment_style = ENV["GOVUK_ENVIRONMENT_NAME"] == "production" ? "production" : "preview"
