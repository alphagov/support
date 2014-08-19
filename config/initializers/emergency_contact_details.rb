config = File.join(Rails.root, "config", "emergency_contact_details.yml")
EMERGENCY_CONTACT_DETAILS = ActiveSupport::HashWithIndifferentAccess.new(YAML.load(File.open(config)))
