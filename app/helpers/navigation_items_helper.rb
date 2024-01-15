module NavigationItemsHelper
  def navigation_items
    return [] unless current_user

    items = []
    items << { text: "Dashboard", href: root_path, active: is_current?(root_path) }
    items << { text: current_user.name, href: signon_account_url }
    items << { text: "Sign out", href: gds_sign_out_path }
    items
  end

  def is_current?(link)
    recognized = Rails.application.routes.recognize_path(link)
    recognized[:controller] == params[:controller] &&
      recognized[:action] == params[:action]
  end

  def signon_account_url
    URI.join(Plek.external_url_for("signon"), "/account").to_s
  end
end
