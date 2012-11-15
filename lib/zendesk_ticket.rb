require 'forwardable'

class ZendeskTicket
  extend Forwardable

  @@in_comments = {"amend-content" => [:other_organisation, :url1, :url2, :url3],
                   "create-user" => [:other_organisation, :user_name, :user_email, :additional],
                   "remove-user" => [:other_organisation, :user_name, :user_email, :additional],
                   "campaign" => [:other_organisation, :campaign_name, :erg_number, :company, :description, :url, :additional],
                   "publish-tool" => [:other_organisation, :username, :url, :user_agent, :additional]
  }

  @@in_subject = {"amend-content" => "Content change request",
                  "create-user" => "Create new user",
                  "remove-user" => "Remove user",
                  "campaign" => "Campaign",
                  "publish-tool" => "Publishing Tool"
  }

  @@in_tag = {"amend-content" => "content_amend",
              "create-user" => "new_user",
              "remove-user" => "remove_user",
              "campaign" => "campaign",
              "publish-tool" => "publishing_tool_tech"
  }

  def initialize(request, from_route)
    @request = request
    @from_route = from_route
  end

  def_delegators :@request, :name, :email, :organisation, :job

  def phone
    if has_value(:phone)
      remove_space_from_phone_number(@request.phone)
    else
      nil
    end
  end

  def comment
    format_comment(@from_route, @request)
  end

  def subject
    @@in_subject[@from_route]
  end

  def not_before_date
    if has_value(:not_before_day)
      @request.not_before_day + "/" + @request.not_before_month + "/" + @request.not_before_year
    else
      nil
    end
  end

  def need_by_date
    if has_value(:need_by_day)
      @request.need_by_day + "/" + @request.need_by_month + "/" + @request.need_by_year
    else
      nil
    end
  end

  def request_specific_tag
    @@in_tag[@from_route]
  end

  def tags
    [request_specific_tag] + inside_government_tag
  end

  private

  def inside_government_tag
    if has_value(:inside_government) and @request.inside_government == "yes"
      ["inside_government"]
    else
      []
    end
  end
    
  def has_value(param, target = nil)
    target ||= @request
    target.respond_to?(param) and not target.send(param).nil? and not target.send(param).strip.empty?
  end

  def format_comment(from_route, request)
    case from_route
      when "amend-content" then
        format_comment_for_amend_content(request)
      when "publish-tool" then
        format_comment_for_tech_issues(from_route, request)
      else
        comment = @@in_comments[from_route].map do |comment_param|
          if request.send(comment_param) && !request.send(comment_param).empty?
            "[" + comment_param.to_s.capitalize.gsub(/_/, " ") + "]\n" + request.send(comment_param)
          end
        end

        if !comment.join().empty?
          comment.join("\n\n")
        else
          comment.join
        end
    end
  end

  def format_comment_for_tech_issues(from_route, request)
    all_comments = @@in_comments[from_route].map do |comment_param|
      comment = ""
      if request.send(comment_param) && !request.send(comment_param).empty?
        comment = "[" + comment_param.to_s.capitalize.gsub(/_/, " ") + "]\n"
        if :url == comment_param
          comment += build_full_url_path(request.url)
        else
          comment += request.send(comment_param)
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

  def format_comment_for_amend_content(request)
    comments_sections = {"[URl(s) of content to be changed]" => [build_full_url_path(request.url1), build_full_url_path(request.url2), build_full_url_path(request.url3)],
                         "[Details of what should be added, amended or removed]" => [request.add_content],
                         "[Additional Comments]" => [request.additional]
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

