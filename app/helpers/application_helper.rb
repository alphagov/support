require 'support/navigation/feedex_section'
require 'support/navigation/section_groups'

module ApplicationHelper
  def accessible_section_groups
    Support::Navigation::SectionGroups.new(current_user).select(&:accessible?)
  end

  def feedex_section
    Support::Navigation::FeedexSection.new(current_user)
  end

  def in_feedex?
    current_page?(controller: "anonymous_feedback/explore", action: :new) ||
      current_page?(controller: 'anonymous_feedback', action: :index)
  end

  def nav_link_to(section, options = { is_active: false })
    content_tag(:li, class: options[:is_active] ? 'active' : '', id: options[:id]) do
      link_to section.label, section.link
    end
  end
end
