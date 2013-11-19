require 'support/permissions/permitted_request_groups'

module ApplicationHelper
  # Set class on active navigation items
  def nav_link(link_text, link_path, list_item_id = nil)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, class: class_name, id: list_item_id) do
      link_to link_text, link_path
    end
  end

  def path_to_new_request(request_class)
    request_class_name = request_class.name.split("::").last
    path_name = "new_#{request_class_name.underscore}_path"
    Rails.application.routes.url_helpers.send(path_name)
  end

  def request_groups
    Support::Permissions::PermittedRequestGroups.new(current_user)
  end

  def feedex_nav_link
    is_on_feedex_page = current_page?(controller: "anonymous_feedback/problem_reports/explore", action: :new) ||
                        current_page?(controller: 'anonymous_feedback/problem_reports', action: :index)
    class_name = is_on_feedex_page ? 'active' : ''

    content_tag(:li, class: class_name, id: "feedex") do
      link_to "Feedback explorer", anonymous_feedback_problem_reports_explore_url
    end
  end
end
