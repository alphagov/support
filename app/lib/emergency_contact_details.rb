class EmergencyContactDetails
  def self.fetch
    config = if ENV["EMERGENCY_CONTACT_DETAILS"]
               JSON.parse(ENV["EMERGENCY_CONTACT_DETAILS"])
             else
               JSON.parse(File.load(Rails.root.join("config", "emergency_contact_details.json")))
             end
    ActiveSupport::HashWithIndifferentAccess.new(config)
  end
end
