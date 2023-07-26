class EmergencyContactDetails
  def self.fetch
    config_str = ENV["EMERGENCY_CONTACT_DETAILS"]
    raise MissingEnvVar if config_str.nil?

    config = JSON.parse(config_str)
    ActiveSupport::HashWithIndifferentAccess.new(config)
  end

  class MissingEnvVar < StandardError; end
end
