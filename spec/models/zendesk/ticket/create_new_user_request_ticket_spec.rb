require "rails_helper"

module Zendesk
  module Ticket
    describe CreateNewUserRequestTicket do
      def ticket(opts = {})
        defaults = { requester: nil, title: nil, organisation: nil }
        CreateNewUserRequestTicket.new(double(defaults.merge(opts)))
      end

      describe "#custom_fields" do
        it "includes mandatory custom_fields" do
          request_ticket = ticket(
            name: "Bob Fields",
            email: "bob@gov.uk",
            formatted_whitehall_training_option: "No, the user does not need to draft or publish content on Whitehall Publisher",
          )
          expect(request_ticket.custom_fields).to eq([
            { "id" => 16_186_374_142_108, "value" => "Bob Fields" },
            { "id" => 16_186_377_836_316, "value" => "bob@gov.uk" },
            { "id" => 16_186_461_678_108, "value" => "whitehall_training_required_none" },
          ])
        end

        it "includes optional fields in custom_fields if they are present" do
          request_ticket = ticket(
            name: "Bob Fields",
            email: "bob@gov.uk",
            organisation: "Cabinet Office (CO)",
            formatted_whitehall_training_option: "No, the user does not need to draft or publish content on Whitehall Publisher",
          )
          expect(request_ticket.custom_fields).to eq([
            { "id" => 16_186_374_142_108, "value" => "Bob Fields" },
            { "id" => 16_186_377_836_316, "value" => "bob@gov.uk" },
            { "id" => 16_186_461_678_108, "value" => "whitehall_training_required_none" },
            { "id" => 16_186_432_238_236, "value" => "Cabinet Office (CO)" },
          ])
        end
      end
    end
  end
end
