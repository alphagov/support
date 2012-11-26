require 'forwardable'
require 'date'
require 'active_support'

class ZendeskTicket
  extend Forwardable

  @@in_comments = {"remove-user" => [:other_organisation, :user_name, :user_email, :additional],
                   "campaign" => [:other_organisation, :campaign_name, :erg_number, :company, :description, :url, :additional],
                   "publish-tool" => [:other_organisation, :username, :url, :user_agent, :additional]
  }

  @@in_subject = {"remove-user" => "Remove user",
                  "campaign" => "Campaign",
                  "publish-tool" => "Publishing Tool"
  }

  @@in_tag = {"remove-user" => "remove_user",
              "campaign" => "campaign",
              "publish-tool" => "publishing_tool_tech"
  }

  def initialize(request, from_route)
    @request = request
    @from_route = from_route
  end

  def_delegators :@request, :name, :email, :organisation, :job

  def phone
    # TODO: solve this horrible mess when the refactor is done
    if instance_variable_defined?("@requester")
      if has_value?(:phone, @requester)
        remove_space_from_phone_number(@requester.phone)
      else
        nil
      end
    else
      if has_value?(:phone)
        remove_space_from_phone_number(@request.phone)
      else
        nil
      end
    end
  end

  def comment
    if respond_to?(:comment_snippets)
      applicable_snippets = comment_snippets.select(&:applies?)
      applicable_snippets.collect(&:to_s).join("\n\n")
    else
      # TODO: remove this when the refactor is complete
      format_comment(@from_route, @request)
    end
  end

  def subject
    @@in_subject[@from_route]
  end

  def not_before_date
    # TODO sort this mess out
    if has_value?(:time_constraint) and has_value?(:not_before_date, @request.time_constraint)
      @request.time_constraint.not_before_date
    elsif has_value?(:not_before_day)
      @request.not_before_day + "/" + @request.not_before_month + "/" + @request.not_before_year
    else
      nil
    end
  end

  def needed_by_date
    # TODO sort this mess out
    if has_value?(:time_constraint) and has_value?(:needed_by_date, @request.time_constraint)
      @request.time_constraint.needed_by_date
    elsif has_value?(:need_by_day)
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
    if has_value?(:inside_government) and @request.inside_government == "yes"
      ["inside_government"]
    else
      []
    end
  end
    
  def has_value?(param, target = nil)
    target ||= @request
    target.respond_to?(param) and not target.send(param).blank?
  end

  def format_comment(from_route, request)
    case from_route
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

