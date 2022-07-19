class EmergencyContactDetails
  def self.fetch
    config = JSON.parse(ENV["EMERGENCY_CONTACT_DETAILS"]) ||
      JSON.parse(File.load(Rails.root.join("config/emergency_contact_details.json")))
    ActiveSupport::HashWithIndifferentAccess.new(config)
  end
end
