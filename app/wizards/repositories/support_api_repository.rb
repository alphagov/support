# frozen_string_literal: true

module Repositories
  class SupportApiRepository < DfE::Wizard::Repository::Base
    attr_reader :support_app_reference

    def initialize(support_app_reference)
      super()
      @support_app_reference = support_app_reference
    end

    def read
      draft_request = Services.support_api.get_draft_support_request(support_app_reference)
      draft_request["data"].with_indifferent_access
    rescue GdsApi::HTTPNotFound
      {}
    end

    def write(data)
      draft_request_data = read

      current_data = draft_request_data || {}
      draft_request_data = current_data.merge(data.stringify_keys)

      Services.support_api.put_draft_support_request(support_app_reference, { support_app_reference:, data: draft_request_data })
    end

    def clear
      # TODO: new endpoint on support api that deletes the `DraftSupportRequest` record
      # TODO: clear the reference stored in support app's `session`
    end
  end
end
