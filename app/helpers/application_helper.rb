module ApplicationHelper
  def feedex_section
    Support::Navigation::FeedexSection.new(current_user)
  end

  def in_feedex?
    current_page?("/anonymous_feedback/explore")
  end

  def nav_link_to(section, options = { is_active: false })
    list_class = if options[:is_active]
                   "active"
                 elsif !section.accessible?
                   "disabled"
                 else
                   ""
                 end

    tag.li(class: list_class, id: options[:id]) do
      link_to section.label, section.link
    end
  end
end
