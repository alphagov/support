module ApplicationHelper
  # Set class on active navigation items
  def nav_link(text, link)
    options = link_to_current_route?(link) ? { class: "active" } : {}
    content_tag(:li, options) do
      link_to( text, link)
    end
  end

  protected
  def link_to_current_route?(link)
    recognized = Rails.application.routes.recognize_path(link)
    recognized[:controller] == params[:controller] &&
      recognized[:action] == params[:action]
  end
end
