require 'bundler'
Bundler.require

class ZendeskTicket

  attr_reader :name, :email, :department, :job, :phone, :comment, :subject, :tag, :need_by_date, :not_before_date, :file_token
  @@in_comments = {"new" => [:additional],
                  "amend-content" => [:url_add1, :url_add2, :url_add3, :url_old1, :url_old2, :url_old3, :place_to_remove1, :place_to_remove2, :place_to_remove3],
                  "create-user" => [:user_name, :user_email, :additional],
                  "remove-user" => [:user_name, :user_email, :additional],
                  "reset-password" => [:user_name, :user_email, :additional],
                  "campaign" => [:campaign_name, :erg_number, :company, :description, :url, :additional],
                  "broken-link" => [:url, :additional],
                  "publish-tool" => [:username, :url, :additional]
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
             "amend-content" => "content_change",
             "create-user" => "new_user",
             "remove-user" => "remove_user",
             "reset-password" => "password_reset",
             "campaign" => "campaign",
             "broken-link" => "broken_link",
             "publish-tool" => "publishing_tool"
  }

  def initialize(params, from_route)
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

    check_for_attachments(from_route, params)
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
        @@in_comments[from_route].map { |comment_param| params[comment_param] }.join("\n\n")
    end
  end

  def format_comment_for_tech_issues(from_route, params)
    all_comments = @@in_comments[from_route].map do |comment_param|
                                                  p "THE CPARSM #{comment_param.class}"
                                                  p "url" === comment_param
                                                  if :url == comment_param
                                                    build_full_url_path(params[:url])
                                                  else
                                                    params[comment_param]
                                                  end
                                                end
    all_comments.join("\n\n")
  end

  def format_comment_for_amend_content(params)
    url_add_array = [params[:url_add1], params[:url_add2], params[:url_add3]]
    url_old_array = [params[:url_old1], params[:url_old2], params[:url_add3]]
    url_remove_array = [params[:place_to_remove1], params[:place_to_remove2], params[:place_to_remove3]]
    url_add = url_old = url_remove = ""
    url_add_array.each{|au| url_add += au.empty?? au : build_full_url_path(au) + "\n"}
    url_old_array.each{|ou| url_old += ou.empty?? ou : build_full_url_path(ou) + "\n"}
    url_remove_array.each{|ru| url_remove += ru.empty?? ru : build_full_url_path(ru) + "\n"}

    comment = (params[:add_content].empty?? "" : "[added content]\n" + params[:add_content] + "\n\n") +
        (url_add.empty?? "" : "[url(s) for adding content]\n" +url_add +"\n\n") +
        (params[:old_content].empty?? "" : "[old content]\n" + params[:old_content] + "\n\n") +
        (url_old.empty?? "" :"[url(s) for old content]\n" + url_old + "\n\n" )+
        (params[:new_content].empty?? "" : "[new content]\n"+ params[:new_content] + "\n\n") +
        (params[:remove_content].empty?? "" : "[remove content]\n"+ params[:remove_content] + "\n\n") +
        (url_remove.empty?? "" : "[url(s) for removing content]\n" + url_remove + "\n\n") +
        (params[:additional].empty?? "" : "[additional]\n" + params[:additional])

    comment
  end

  def remove_space_from_phone_number(number)
    number.gsub(/\s+/, "")
  end

  def build_full_url_path(partial_path)
    "http://gov.uk/"+ partial_path
  end

#  attachments
  def upload_file_to_create_file_token(tempfile, filename)
    directory = "./tmp"
    path = File.join(directory, filename)
    File.open(path, "wb") { |f| f.write(tempfile.read) }
    file_token = ZendeskClient::upload_file(path)
    File.delete(path)
    file_token
  end

  def check_for_attachments(from_route, params)
    @file_token = []
    if params[:uploaded_data]
      tempfile = params[:uploaded_data][:tempfile]
      filename = params[:uploaded_data][:filename]
      @file_token  << upload_file_to_create_file_token(tempfile, filename)
    end

    if "amend-content" == from_route
      if params[:upload_amend]
        tempfile = params[:upload_amend][:tempfile]
        filename = params[:upload_amend][:filename]
        @file_token << upload_file_to_create_file_token(tempfile, filename)
      end
    end
  end


end

