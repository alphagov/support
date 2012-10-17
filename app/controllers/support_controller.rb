require "zendesk_request"
require "zendesk_client"

class SupportController < ApplicationController
  def amend_content
    on_get("Content Change", "content/content_amend_message", "content/amend")
  end

  private

  def on_get(head, head_message_form, template)
    @client = ZendeskClient.get_client(logger)
    @organisations = ZendeskRequest.get_organisations(@client)
    @header = head
    @header_message = head_message_form
    @formdata = {}

    render :"#{template}", :layout => "formlayout"
  end
end