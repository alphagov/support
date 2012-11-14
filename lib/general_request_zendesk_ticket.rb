require 'zendesk_ticket'

class GeneralRequestZendeskTicket < ZendeskTicket
  def initialize(request)
    super(request, nil)
  end

  def subject
    "Govt Agency General Issue"
  end

  def request_specific_tag
    "govt_agency_general"
  end

  def comment
    all_comments = fields_in_comments.map do |comment_param|
      comment = ""
      if @request.send(comment_param) && !@request.send(comment_param).empty?
        comment = "[" + comment_param.to_s.capitalize.gsub(/_/, " ") + "]\n"
        if :url == comment_param
          comment += build_full_url_path(@request.url)
        else
          comment += @request.send(comment_param)
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

  protected
  def fields_in_comments
    [:other_organisation, :url, :user_agent, :additional]
  end
end