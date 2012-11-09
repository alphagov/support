class ZendeskTicket

  attr_reader :phone, :comment, :subject
  @@in_comments = {"amend-content" => [:other_organisation, :url1, :url2, :url3],
                   "create-user" => [:other_organisation, :user_name, :user_email, :additional],
                   "remove-user" => [:other_organisation, :user_name, :user_email, :additional],
                   "campaign" => [:other_organisation, :campaign_name, :erg_number, :company, :description, :url, :additional],
                   "general" => [:other_organisation, :url, :user_agent, :additional],
                   "publish-tool" => [:other_organisation, :username, :url, :user_agent, :additional]
  }

  @@in_subject = {"amend-content" => "Content change request",
                  "create-user" => "Create new user",
                  "remove-user" => "Remove user",
                  "campaign" => "Campaign",
                  "general" => "Govt Agency General Issue",
                  "publish-tool" => "Publishing Tool"
  }

  @@in_tag = {"amend-content" => "content_amend",
              "create-user" => "new_user",
              "remove-user" => "remove_user",
              "campaign" => "campaign",
              "general" => "govt_agency_general",
              "publish-tool" => "publishing_tool_tech"
  }

  def initialize(params, from_route)
    @params = params
    @from_route = from_route
  end

  [:name, :email, :organisation, :job].each do |attr|
    define_method attr, lambda { @params[attr] }
  end

  def phone
    if has_value(@params[:phone])
      remove_space_from_phone_number(@params[:phone])
    else
      nil
    end
  end

  def comment
    format_comment(@from_route, @params)
  end

  def subject
    @@in_subject[@from_route]
  end

  def not_before_date
    if has_value(@params[:not_before_day])
      @params[:not_before_day] + "/" + @params[:not_before_month] + "/" + @params[:not_before_year]
    else
      nil
    end
  end

  def need_by_date
    if has_value(@params[:need_by_day])
      @params[:need_by_day] + "/" + @params[:need_by_month] + "/" + @params[:need_by_year]
    else
      nil
    end
  end

  def tags
    inside_government_tag = @params[:inside_government] == "yes" ? ["inside_government"] : []
    [@@in_tag[@from_route]] + inside_government_tag
  end

  private

  def has_value(param)
    not param.nil? and not param.strip.empty?
  end

  def format_comment(from_route, params)
    case from_route
      when "amend-content" then
        format_comment_for_amend_content(params)
      when "general" then
        format_comment_for_tech_issues(from_route, params)
      when "publish-tool" then
        format_comment_for_tech_issues(from_route, params)
      else
        comment = @@in_comments[from_route].map do |comment_param|
          if params[comment_param] && !params[comment_param].empty?
            "[" + comment_param.to_s.capitalize.gsub(/_/, " ") + "]\n" + params[comment_param]
          end
        end

        if !comment.join().empty?
          comment.join("\n\n")
        else
          comment.join
        end
    end
  end

  def format_comment_for_tech_issues(from_route, params)
    all_comments = @@in_comments[from_route].map do |comment_param|
      comment = ""
      if params[comment_param] && !params[comment_param].empty?
        comment = "[" + comment_param.to_s.capitalize.gsub(/_/, " ") + "]\n"
        if :url == comment_param
          comment += build_full_url_path(params[:url])
        else
          comment += params[comment_param]
        end
      end
      comment
    end

    if !all_comments.join.empty?
      all_comments.join("\n\n")
    else
      all_comments.join
    end
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

    if !comments.join.empty?
      comments.join("\n\n")
    else
      comments.join
    end

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

  def doesFieldHaveValue(field_value)
    field_value && !field_value.strip.empty?
  end

end

