require "rails_helper"

describe EmergencyContactDetails do
  describe ".fetch" do
    it "returns a HashWithIndifferentAccess derived from `ENV['EMERGENCY_CONTACT_DETAILS']`" do
      contact_details = {
        "current_at": "2014-07-01",
        "primary_contacts": {
          "national_emergencies": {
            "phone": "0555 555 555",
          },
        },
        "secondary_contacts": [
          {
            "name": "Billy Director",
            "role": "Director",
            "phone": "05555 555 555",
            "email": "billy.director@email.uk",
          },
        ],
        "verify_contacts": {
          "ida_support_email": "idasupport@email.uk",
          "out_of_hours_email": "outofhours@email.uk",
        },
      }

      allow(ENV).to receive(:[]).with(anything)
      allow(ENV).to receive(:[]).with("EMERGENCY_CONTACT_DETAILS").and_return(contact_details.to_json)
      expect(described_class.fetch).to eq(contact_details.to_h.with_indifferent_access)
      expect(described_class.fetch[:verify_contacts][:ida_support_email]).to eq("idasupport@email.uk")
    end

    it "raises an exception if `ENV['EMERGENCY_CONTACT_DETAILS']` is not defined" do
      allow(ENV).to receive(:[]).with(anything)
      allow(ENV).to receive(:[]).with("EMERGENCY_CONTACT_DETAILS").and_return(nil)

      expect { described_class.fetch }.to raise_exception(EmergencyContactDetails::MissingEnvVar)
    end
  end
end
