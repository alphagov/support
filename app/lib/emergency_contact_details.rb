class EmergencyContactDetails
  def self.fetch
    config_str = ENV["EMERGENCY_CONTACT_DETAILS"] || File.read(Rails.root.join("config/emergency_contact_details.json"))
    config = JSON.parse(config_str)
    ActiveSupport::HashWithIndifferentAccess.new(config)
  end
end
