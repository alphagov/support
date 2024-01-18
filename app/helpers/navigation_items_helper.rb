module NavigationItemsHelper
  def navigation_items
    return [] unless current_user

    items = []
    items << {
      text: "Home",
      href: root_path,
      active: is_current?(root_path),
    }
    if current_user.can? :read, :anonymous_feedback
      items << {
        text: "Feedback explorer",
        href: anonymous_feedback_explore_path,
        active: is_current?(anonymous_feedback_explore_path),
      }
    end
    items << {
      text: "GOV.UK Zendesk",
      href: "https://govuk.zendesk.com/",
      active: false,
    }
    items << {
      text: "Switch app",
      href: signon_root_url,
      active: false,
    }
    items << {
      text: current_user.name,
      href: signon_account_url,
      active: false,
    }
    items << {
      text: "Sign out",
      href: gds_sign_out_path,
      active: false,
    }
    items
  end

  def is_current?(link)
    recognized = Rails.application.routes.recognize_path(link)
    recognized[:controller] == params[:controller] &&
      recognized[:action] == params[:action]
  end

  def signon_root_url
    URI.join(Plek.external_url_for("signon"), "/").to_s
  end

  def signon_account_url
    URI.join(signon_root_url, "account").to_s
  end
end
