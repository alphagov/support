require "rails_helper"

module Support
  module GDS
    describe Campaign do
      def as_str(date)
        date.strftime("%d-%m-%Y")
      end

      subject do
        Campaign.new(
          signed_campaign: "Test Signer",
          has_read_guidance_confirmation: "1",
          has_read_oasis_guidance_confirmation: "1",
          start_date: as_str(Time.zone.today),
          end_date: as_str(Date.tomorrow),
          development_start_date: as_str(Time.zone.today),
          performance_review_contact_email: "test@digital.cabinet-office.gov.uk",
          government_theme: "Test theme",
          description: "Test Description",
          call_to_action: "Test Call to Action",
          proposed_url: "example.campaign.gov.uk",
          site_metadescription: "tag1, tag2",
          cost_of_campaign: 1200,
          ga_contact_email: "ga_test@digital.cabinet-office.gov.uk",
        )
      end

      it { should validate_presence_of(:signed_campaign) }
      it { should validate_presence_of(:start_date) }
      it { should validate_presence_of(:end_date) }
      it { should validate_presence_of(:development_start_date) }
      it { should validate_presence_of(:performance_review_contact_email) }
      it { should validate_presence_of(:government_theme) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:call_to_action) }
      it { should validate_presence_of(:proposed_url) }
      it { should validate_presence_of(:site_title) }
      it { should validate_presence_of(:site_tagline) }
      it { should validate_presence_of(:site_metadescription) }
      it { should validate_presence_of(:cost_of_campaign) }
      it { should validate_presence_of(:ga_contact_email) }

      it { should validate_acceptance_of(:has_read_guidance_confirmation) }
      it { should validate_acceptance_of(:has_read_oasis_guidance_confirmation) }

      it { should validate_acceptance_of(:has_read_guidance_confirmation) }
      it { should validate_acceptance_of(:has_read_oasis_guidance_confirmation) }

      it { should allow_value("example.gov.uk").for(:proposed_url) }
      it { should allow_value("example.campaign.gov.uk").for(:proposed_url) }
      it { should_not allow_value("Non Campaign platform").for(:proposed_url) }

      it { should_not allow_value("xxx").for(:start_date) }
      it { should_not allow_value("xxx").for(:end_date) }
      it { should_not allow_value("xxx").for(:development_start_date) }

      it { should allow_value("test@digital.cabinet-office.gov.uk").for(:performance_review_contact_email) }
      it { should allow_value("test@test.com").for(:performance_review_contact_email) }
      it { should allow_value("test@test.co.uk").for(:performance_review_contact_email) }
      it { should_not allow_value(1234).for(:performance_review_contact_email) }
      it { should_not allow_value("1234").for(:performance_review_contact_email) }
      it { should_not allow_value("test").for(:performance_review_contact_email) }
      it { should_not allow_value("test@").for(:performance_review_contact_email) }

      it { should allow_value(as_str(Date.tomorrow)).for(:start_date) }
      it { should allow_value(as_str(Time.zone.today)).for(:start_date) }
      it { should_not allow_value(as_str(Time.zone.today - 1)).for(:start_date) }

      it { should allow_value(as_str(Date.tomorrow)).for(:end_date) }
      it { should_not(allow_value(as_str(Time.zone.today)).for(:end_date)) }

      it { should_not allow_value(as_str(Date.tomorrow)).for(:development_start_date) }
      it { should allow_value(as_str(Time.zone.today - 1)).for(:development_start_date) }
      it { should allow_value(as_str(Time.zone.today)).for(:development_start_date) }

      it { should allow_value("test@digital.cabinet-office.gov.uk").for(:ga_contact_email) }
      it { should allow_value("test@test.com").for(:ga_contact_email) }
      it { should allow_value("test@test.co.uk").for(:ga_contact_email) }
      it { should_not allow_value(1234).for(:ga_contact_email) }
      it { should_not allow_value("1234").for(:ga_contact_email) }
      it { should_not allow_value("test").for(:ga_contact_email) }
      it { should_not allow_value("test@").for(:ga_contact_email) }
    end
  end
end
