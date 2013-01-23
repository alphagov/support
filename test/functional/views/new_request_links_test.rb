require 'test_helper'

class NewRequestLinksTest < ActionView::TestCase
  def test_rendering_of_active_links
    view.stubs(:current_page?).returns(true)

    render "support/new_request_links", request_groups: RequestGroups.new

    assert_select "div.sidebar-nav li.active"
  end

  def test_rendering_of_inactive_links
    view.stubs(:current_page?).returns(false)

    render "support/new_request_links", request_groups: RequestGroups.new

    assert_select "div.sidebar-nav li.active", 0
  end
end
