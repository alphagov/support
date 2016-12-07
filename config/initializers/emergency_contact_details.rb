if ENV["EMERGENCY_CONTACT_DETAILS"]
  config = JSON.parse(ENV["EMERGENCY_CONTACT_DETAILS"])
else
  config = JSON.load(Rails.root.join("config", "emergency_contact_details.json"))
end

EMERGENCY_CONTACT_DETAILS = ActiveSupport::HashWithIndifferentAccess.new(config)
