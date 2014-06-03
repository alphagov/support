require 'test_helper'
require 'support/navigation/section_groups'

class NewRequestLinksTest < ActionView::TestCase
  include Support::Navigation

  def setup
    super
    view.stubs(:current_user).returns(@user)
  end

  def test_rendering_of_active_links
    view.stubs(:current_page?).returns(true)

    render "support/new_request_links", section_groups: SectionGroups.new(@user)

    assert_select "ul.dropdown-menu li.active"
  end

  def test_rendering_of_inactive_links
    view.stubs(:current_page?).returns(false)

    render "support/new_request_links", section_groups: SectionGroups.new(@user)

    assert_select "ul.dropdown-menu li.active", false
  end

  def test_rendering_of_feedex_link
    render "support/new_request_links", section_groups: SectionGroups.new(@user)

    assert_select "#feedex a", "Feedback explorer"
  end

  def test_inaccessible_links_are_greyed_out
    @user.stubs(:can?).returns(false)

    render "support/new_request_links", section_groups: SectionGroups.new(@user)

    assert_select "#feedex.disabled a"
    assert_select "ul.dropdown-menu li.disabled"
  end
end
