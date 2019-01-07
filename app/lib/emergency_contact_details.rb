class EmergencyContactDetails
  def self.fetch
    if ENV["EMERGENCY_CONTACT_DETAILS"]
      config = JSON.parse(ENV["EMERGENCY_CONTACT_DETAILS"])
    else
      config = JSON.load(Rails.root.join("config", "emergency_contact_details.json"))
    end
    ActiveSupport::HashWithIndifferentAccess.new(config)
  end
end
