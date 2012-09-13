require 'bundler'
Bundler.require

class ZendeskTicket

  attr_reader :name, :email, :department, :job, :phone, :comment, :subject, :tag, :need_by_date, :not_before_date, :file_token
  @@in_comments = {"new" => [:additional],
                   "amend-content" => [:url1, :url2, :url3],
                   "create-user" => [:user_name, :user_email, :additional],
                   "remove-user" => [:user_name, :user_email, :additional],
                   "reset-password" => [:user_name, :user_email, :additional],
                   "campaign" => [:campaign_name, :erg_number, :company, :description, :url, :additional],
                   "broken-link" => [:url, :user_agent, :additional],
                   "publish-tool" => [:username, :url, :user_agent, :additional]
  }

  @@in_subject = {"new" => "New Need",
                  "amend-content" => "Content change request",
                  "create-user" => "Create new user",
                  "remove-user" => "Remove user",
                  "reset-password" => "Reset Password",
                  "campaign" => "Campaign",
                  "broken-link" => "Broken Link",
                  "publish-tool" => "Publishing Tool"
  }

  @@in_tag = {"new" => "new_need",
              "amend-content" => "content_amend",
              "create-user" => "new_user",
              "remove-user" => "remove_user",
              "reset-password" => "password_reset",
              "campaign" => "campaign",
              "broken-link" => "broken_link",
              "publish-tool" => "publishing_tool_tech"
  }

  def initialize(client, params, from_route)
    #author information
    @name = params[:name]
    @email = params[:email]
    @department = params[:department]
    @job = params[:job]
    if has_value(params[:phone])
      @phone = remove_space_from_phone_number(params[:phone])
    end

    #ticket information
    @comment = format_comment(from_route, params)
    @subject = @@in_subject[from_route]
    @tag = @@in_tag[from_route]

    if has_value(params[:need_by_day])
      @need_by_date = params[:need_by_day] + "/" + params[:need_by_month] + "/" + params[:need_by_year]
    end

    if has_value(params[:not_before_day])
      @not_before_date = params[:not_before_day] + "/" + params[:not_before_month] + "/" + params[:not_before_year]
    end

    check_for_attachments(client, params)
  end


  def has_attachments
    @file_token.length > 0
  end


  private

  def has_value(param)
    if param
      !param.strip.empty?
    else
      false
    end
  end

  def format_comment(from_route, params)
    case from_route
      when "amend-content" then
        format_comment_for_amend_content(params)
      when "broken-link" then
        format_comment_for_tech_issues(from_route, params)
      when "publish-tool" then
        format_comment_for_tech_issues(from_route, params)
      else
        @@in_comments[from_route].map { |comment_param| "[" + comment_param.to_s.capitalize + "]\n" + params[comment_param] }.join("\n\n")
    end
  end

  def format_comment_for_tech_issues(from_route, params)
    all_comments = @@in_comments[from_route].map do |comment_param|
      comment = "[" + comment_param.to_s.capitalize + "]\n"
      if :url == comment_param
        comment += build_full_url_path(params[:url])
      else
        comment += params[comment_param]
      end
      comment
    end
    all_comments.join("\n\n")
  end

  def format_comment_for_amend_content(params)
    comments_sections = {"[URl(s) of content to be changed]" => [build_full_url_path(params[:url1]), build_full_url_path(params[:url2]), build_full_url_path(params[:url3])],
              "[Details of what should be added, amended or removed]" => [params[:add_content]],
              "[Additional Comments]" => [params[:additional]]
    }

    comments = comments_sections.map do |key, value|
      allvalues = value.join("\n")
      if !allvalues.chomp.strip.empty?
        key+"\n"+allvalues.chomp.strip
      end
    end

    comments.join("\n\n")
  end

  def remove_space_from_phone_number(number)
    number.gsub(/\s+/, "")
  end

  def build_full_url_path(partial_path)
    if partial_path && !partial_path.empty?
      "http://gov.uk/"+ partial_path
    else
      partial_path
    end
  end

#  attachments
  def upload_file_to_create_file_token(client, tempfile, filename)
    directory = "./tmp"
    path = File.join(directory, filename)
    File.open(path, "wb") { |f| f.write(tempfile.read) }
    file_token = upload_file(client, path)
    File.delete(path)
    file_token
  end

  def upload_file(client, path)
    upload = ZendeskAPI::Upload.create(client, :file => File.open(path))
    upload.token
  end

  def check_for_attachments(client, params)
    @file_token = []
    if params[:uploaded_data] && doesFieldHaveValue(params[:uploaded_data][:filename])
      tempfile = params[:uploaded_data][:tempfile]
      filename = params[:uploaded_data][:filename]
      @file_token << upload_file_to_create_file_token(client, tempfile, filename)
    end
  end

  def doesFieldHaveValue(field_value)
    field_value && !field_value.strip.empty?
  end

end

