module Zendesk
  module Ticket
    class CreateNewUserOrTrainingRequestTicket < Zendesk::ZendeskTicket
      TICKET_FORM_ID = 16_186_592_181_660

      def subject
        @request.formatted_action
      end

      def tags
        super + [@request.action]
      end

      def collaborator_emails
        super + [@request.email]
      end

      def custom_fields
        fields = [
          CustomField.set(id: 16_186_374_142_108, input: @request.name),
          CustomField.set(id: 16_186_377_836_316, input: @request.email),
          CustomField.set(id: 18_626_821_668_764, input: @request.formatted_new_or_existing_user_option),
          CustomField.set(id: 16_186_461_678_108, input: @request.formatted_whitehall_training_option),
          CustomField.set(id: 16_186_526_602_396, input: @request.formatted_access_to_other_publishing_apps_option),
        ]
        fields << CustomField.set(id: 16_186_432_238_236, input: @request.organisation) if @request.organisation
        fields << CustomField.set(id: 18_626_967_621_276, input: @request.formatted_writing_for_govuk_training_option) if @request.writing_for_govuk_training.present?
        fields
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :formatted_action,
            label: "Action",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :name,
            label: "Requested user's name",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :email,
            label: "Requested user's email",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :organisation,
            label: "Organisation",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :formatted_new_or_existing_user_option,
            label: "New or existing user",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :formatted_whitehall_training_option,
            label: "Training or access to Whitehall Publisher",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :formatted_access_to_other_publishing_apps_option,
            label: "Access to other publishing apps",
          ),
          Zendesk::LabelledSnippet.new(
            on: @request,
            field: :formatted_writing_for_govuk_training_option,
            label: "Writing for GOV.UK training",
          ),
          Zendesk::LabelledSnippet.new(on: @request, field: :additional_comments),
        ]
      end
    end
  end
end
