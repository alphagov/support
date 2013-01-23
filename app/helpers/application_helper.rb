module ApplicationHelper
  # Set class on active navigation items
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to link_text, link_path
    end
  end

  def path_to_new_request(request_class)
    path_name = "new_#{request_class.name.underscore}_path"
    Rails.application.routes.url_helpers.send(path_name)
  end
end
