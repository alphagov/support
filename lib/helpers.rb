require_relative "zendesk_client"

def build_full_url_path(partial_path)
  url = "http://gov.uk/"+ partial_path
end

def upload_file_create_file_token(tempfile, filename)
  directory = "./tmp"
  path = File.join(directory, filename)
  File.open(path, "wb") { |f| f.write(tempfile.read) }
  file_token = ZendeskClient::upload_file(path)
  File.delete(path)
  file_token
end

def create_ticket_with_uploaded_file(params, subject, tag, comment, need_by, not_before)
  file_token = []
  if params[:uploaded_data]
    tempfile = params[:uploaded_data][:tempfile]
    filename = params[:uploaded_data][:filename]
    file_token = file_token + [upload_file_create_file_token(tempfile, filename)]
  end

  if params[:upload_amend]
    tempfile = params[:upload_amend][:tempfile]
    filename = params[:upload_amend][:filename]
    file_token = file_token + [upload_file_create_file_token(tempfile, filename)]
  end

  ZendeskClient::create_ticket_with_attachment(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before, file_token)
end

def build_date(params)
  need_by = not_before = nil
  if params[:need_by_day]
    need_by = params[:"need_by_day"] + "/" + params[:"need_by_month"] + "/" + params[:"need_by_year"]
  end
  if params[:not_before_day]
    not_before = params[:"not_before_day"] + "/" + params[:"not_before_month"] + "/" + params[:"not_before_year"]
  end
  return need_by, not_before
end


def load_page(head, head_message_form, template, layout, params)
  @departments = ZendeskClient.get_departments
  @header = head
  @header_message = :"#{head_message_form}"
  @formdata = params

  erb :"#{template}", :layout => :"#{layout}"
end
