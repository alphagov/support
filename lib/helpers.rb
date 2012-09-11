require_relative "zendesk_client"

def load_page(head, head_message_form, template, layout, params)
  @departments = ZendeskClient.get_departments
  @header = head
  @header_message = :"#{head_message_form}"
  @formdata = params

  erb :"#{template}", :layout => :"#{layout}"
end
