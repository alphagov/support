require "rails_helper"

module Zendesk
  module Ticket
    describe CreateNewUserOrTrainingRequestTicket do
      def ticket(opts = {})
        defaults = { requester: nil, title: nil, organisation: nil, writing_for_govuk_training: nil }
        CreateNewUserOrTrainingRequestTicket.new(double(defaults.merge(opts)))
      end

      describe "#custom_fields" do
        it "includes mandatory custom_fields" do
          request_ticket = ticket(
            name: "Bob Fields",
            email: "bob@gov.uk",
            formatted_new_or_existing_user_option: "They’re a new user and do not have a Production account",
            formatted_whitehall_training_option: "No, the user does not need to draft or publish content on Whitehall Publisher",
            formatted_access_to_other_publishing_apps_option: "No, the user does not need access to any other publishing application",
          )
          expect(request_ticket.custom_fields).to eq([
            { "id" => 16_186_374_142_108, "value" => "Bob Fields" },
            { "id" => 16_186_377_836_316, "value" => "bob@gov.uk" },
            { "id" => 18_626_821_668_764, "value" => "whitehall_training_new_user" },
            { "id" => 16_186_461_678_108, "value" => "whitehall_training_required_none" },
            { "id" => 16_186_526_602_396, "value" => "whitehall_training_additional_apps_access_no" },
          ])
        end

        it "includes optional fields in custom_fields if they are present" do
          request_ticket = ticket(
            name: "Bob Fields",
            email: "bob@gov.uk",
            organisation: "Cabinet Office (CO)",
            formatted_new_or_existing_user_option: "They’re a new user and do not have a Production account",
            formatted_whitehall_training_option: "No, the user does not need to draft or publish content on Whitehall Publisher",
            formatted_access_to_other_publishing_apps_option: "No, the user does not need access to any other publishing application",
            writing_for_govuk_training: "whitehall_training_writing_for_govuk_required_no",
            formatted_writing_for_govuk_training_option: "No, the user does not need Writing for GOV.UK training",
          )
          expect(request_ticket.custom_fields).to eq([
            { "id" => 16_186_374_142_108, "value" => "Bob Fields" },
            { "id" => 16_186_377_836_316, "value" => "bob@gov.uk" },
            { "id" => 18_626_821_668_764, "value" => "whitehall_training_new_user" },
            { "id" => 16_186_461_678_108, "value" => "whitehall_training_required_none" },
            { "id" => 16_186_526_602_396, "value" => "whitehall_training_additional_apps_access_no" },
            { "id" => 16_186_432_238_236, "value" => "Cabinet Office (CO)" },
            { "id" => 18_626_967_621_276, "value" => "whitehall_training_writing_for_govuk_required_no" },
          ])
        end
      end
    end
  end
end
