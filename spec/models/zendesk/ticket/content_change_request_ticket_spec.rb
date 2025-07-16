require "rails_helper"

module Zendesk
  module Ticket
    describe ContentChangeRequestTicket do
      def ticket(opts = {})
        defaults = { requester: nil, title: nil }
        ContentChangeRequestTicket.new(double(defaults.merge(opts)))
      end

      def with_time_constraint(attributes)
        { time_constraint: OpenStruct.new(attributes) }
      end

      it "has the title in the subject, if one is provided" do
        expect(ticket(title: "Abc").subject).to eq("Abc")
      end

      it "has a default subject" do
        expect(ticket.subject).to eq("Content change request")
      end

      it 'includes a "content_amend" tag' do
        expect(ticket.tags).to include("content_amend")
      end

      it "includes custom_fields" do
        request_ticket = ticket(
          reason_for_change: "Factual inaccuracy",
          subject_area: "Benefits",
          url: "https://www.gov.uk",
        )
        expect(request_ticket.custom_fields).to eq([
          { "id" => 7_948_652_819_356, "value" => "cr_inaccuracy" },
          { "id" => 7_949_106_580_380, "value" => "cr_benefits" },
          { "id" => 19_824_287_274_012, "value" => "https://www.gov.uk" },
        ])
      end

      it "includes optional fields in custom_fields if they are present" do
        request_ticket = ticket(
          reason_for_change: "Factual inaccuracy",
          subject_area: "Benefits",
          url: "https://www.gov.uk",
          time_constraint: OpenStruct.new(
            needed_by_date: "15-09-2023",
            not_before_date: "10-09-2023",
            needed_by_time: "09:00",
            not_before_time: "09:00",
          ),
        )
        expect(request_ticket.custom_fields).to eq([
          { "id" => 7_948_652_819_356, "value" => "cr_inaccuracy" },
          { "id" => 7_949_106_580_380, "value" => "cr_benefits" },
          { "id" => 19_824_287_274_012, "value" => "https://www.gov.uk" },
          { "id" => 7_949_136_091_548, "value" => "2023-09-15" },
          { "id" => 7_949_152_975_772, "value" => "2023-09-10" },
          { "id" => 8_250_061_570_844, "value" => "09:00" },
          { "id" => 8_250_075_489_052, "value" => "09:00" },
        ])
      end
    end
  end
end
