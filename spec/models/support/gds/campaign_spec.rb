require "rails_helper"

module Support
  module GDS
    describe Campaign do
      def as_str(date)
        date.strftime("%d-%m-%Y")
      end

      let(:required_attr) do
        {
          signed_campaign: "Test Signer",
          has_read_guidance_confirmation: "Yes",
          has_read_oasis_guidance_confirmation: "Yes",
          full_responsibility_confirmation: "Yes",
          accessibility_confirmation: "Yes",
          cookie_and_privacy_notice_confirmation: "Yes",
          start_day: Time.zone.today.strftime("%d"),
          start_month: Time.zone.today.strftime("%m"),
          start_year: Time.zone.today.strftime("%Y"),
          end_day: Time.zone.tomorrow.strftime("%d"),
          end_month: Time.zone.tomorrow.strftime("%m"),
          end_year: Time.zone.tomorrow.strftime("%Y"),
          development_start_day: Time.zone.today.strftime("%d"),
          development_start_month: Time.zone.today.strftime("%m"),
          development_start_year: Time.zone.today.strftime("%Y"),
          performance_review_contact_email: "test@digital.cabinet-office.gov.uk",
          government_theme: "Test theme",
          description: "Test Description",
          call_to_action: "Test Call to Action",
          proposed_url: "example.campaign.gov.uk",
          site_title: "Some title",
          site_tagline: "Some tagline",
          site_metadescription: "tag1, tag2",
          cost_of_campaign: 1200,
          hmg_code: "HMGXX-XXX",
          strategic_planning_code: "CSBXX-XXX",
        }
      end

      subject do
        Campaign.new(required_attr)
      end

      it { should validate_presence_of(:signed_campaign) }
      it { should validate_presence_of(:start_day) }
      it { should validate_presence_of(:start_month) }
      it { should validate_presence_of(:start_year) }
      it { should validate_presence_of(:end_day) }
      it { should validate_presence_of(:end_month) }
      it { should validate_presence_of(:end_year) }
      it { should validate_presence_of(:development_start_day) }
      it { should validate_presence_of(:development_start_month) }
      it { should validate_presence_of(:development_start_year) }
      it { should validate_presence_of(:performance_review_contact_email) }
      it { should validate_presence_of(:government_theme) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:call_to_action) }
      it { should validate_presence_of(:proposed_url) }
      it { should validate_presence_of(:site_title) }
      it { should validate_presence_of(:site_tagline) }
      it { should validate_presence_of(:site_metadescription) }
      it { should validate_presence_of(:cost_of_campaign) }
      it { should validate_presence_of(:hmg_code) }
      it { should validate_presence_of(:strategic_planning_code) }

      it { should validate_acceptance_of(:has_read_guidance_confirmation) }
      it { should validate_acceptance_of(:has_read_oasis_guidance_confirmation) }
      it { should validate_acceptance_of(:full_responsibility_confirmation) }
      it { should validate_acceptance_of(:accessibility_confirmation) }
      it { should validate_acceptance_of(:cookie_and_privacy_notice_confirmation) }

      it { should allow_value("example.gov.uk").for(:proposed_url) }
      it { should allow_value("example.campaign.gov.uk").for(:proposed_url) }
      it { should_not allow_value("Non Campaign platform").for(:proposed_url) }

      it "should not allow 'start date' values to be random characters " do
        constraint = Campaign.new(
          start_day: "xxx",
          start_month: "xxx",
          start_year: "xxx",
        )
        expect(constraint).to_not be_valid
      end

      it "should not allow 'end date' values to be random characters " do
        constraint = Campaign.new(
          end_day: "xxx",
          end_month: "xxx",
          end_year: "xxx",
        )
        expect(constraint).to_not be_valid
      end

      it "should not allow 'development start date' values to be random characters " do
        constraint = Campaign.new(
          development_start_day: "xxx",
          development_start_month: "xxx",
          development_start_year: "xxx",
        )
        expect(constraint).to_not be_valid
      end

      it { should allow_value("test@digital.cabinet-office.gov.uk").for(:performance_review_contact_email) }
      it { should allow_value("test@test.com").for(:performance_review_contact_email) }
      it { should allow_value("test@test.co.uk").for(:performance_review_contact_email) }
      it { should_not allow_value(1234).for(:performance_review_contact_email) }
      it { should_not allow_value("1234").for(:performance_review_contact_email) }
      it { should_not allow_value("test").for(:performance_review_contact_email) }
      it { should_not allow_value("test@").for(:performance_review_contact_email) }

      it "allows the start date to be after today" do
        required_attr[:start_day] = Time.zone.tomorrow.strftime("%d")
        required_attr[:start_month] = Time.zone.tomorrow.strftime("%m")
        required_attr[:start_year] = Time.zone.tomorrow.strftime("%Y")

        required_attr[:end_day] = (Time.zone.tomorrow + 1).strftime("%d")
        required_attr[:end_month] = (Time.zone.tomorrow + 1).strftime("%m")
        required_attr[:end_year] = (Time.zone.tomorrow + 1).strftime("%Y")

        constraint = Campaign.new(required_attr)
        expect(constraint).to be_valid
      end

      it "allows the start date to be today" do
        constraint = Campaign.new(required_attr)
        expect(constraint).to be_valid
      end

      it "doesn't allow the start date to in the past" do
        required_attr[:start_day] = Time.zone.yesterday.strftime("%d")
        required_attr[:start_month] = Time.zone.yesterday.strftime("%m")
        required_attr[:start_year] = Time.zone.yesterday.strftime("%Y")

        constraint = Campaign.new(required_attr)
        expect(constraint).to_not be_valid
      end

      it "allows the end date to be after the start day" do
        required_attr[:end_day] = Time.zone.tomorrow.strftime("%d")
        required_attr[:end_month] = Time.zone.tomorrow.strftime("%m")
        required_attr[:end_year] = Time.zone.tomorrow.strftime("%Y")

        constraint = Campaign.new(required_attr)
        expect(constraint).to be_valid
      end

      it "should not allow the end date to be before the start date" do
        required_attr[:end_day] = Time.zone.today.strftime("%d")
        required_attr[:end_month] = Time.zone.today.strftime("%m")
        required_attr[:end_year] = Time.zone.today.strftime("%Y")

        constraint = Campaign.new(required_attr)
        expect(constraint).to_not be_valid
      end

      it "should not allow the development start date to be after start date" do
        required_attr[:development_start_day] = Time.zone.tomorrow.strftime("%d")
        required_attr[:development_start_month] = Time.zone.tomorrow.strftime("%m")
        required_attr[:development_start_year] = Time.zone.tomorrow.strftime("%Y")

        constraint = Campaign.new(required_attr)
        expect(constraint).to_not be_valid
      end

      it "should allow the development start date to be before the start date" do
        required_attr[:development_start_day] = Time.zone.yesterday.strftime("%d")
        required_attr[:development_start_month] = Time.zone.yesterday.strftime("%m")
        required_attr[:development_start_year] = Time.zone.yesterday.strftime("%Y")

        constraint = Campaign.new(required_attr)
        expect(constraint).to be_valid
      end

      it "should allow the development start date to be on the start date" do
        required_attr[:development_start_day] = Time.zone.today.strftime("%d")
        required_attr[:development_start_month] = Time.zone.today.strftime("%m")
        required_attr[:development_start_year] = Time.zone.today.strftime("%Y")

        constraint = Campaign.new(required_attr)
        expect(constraint).to be_valid
      end
    end
  end
end
