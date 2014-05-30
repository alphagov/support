require 'test_helper'
require 'support/requests/request_groups'

class NewRequestLinksTest < ActionView::TestCase
  def setup
    super
    view.stubs(:current_user).returns(@user)
  end

  def test_rendering_of_active_links
    view.stubs(:current_page?).returns(true)

    render "support/new_request_links", request_groups: Support::Requests::RequestGroups.new

    assert_select "ul.dropdown-menu li.active"
  end

  def test_rendering_of_inactive_links
    view.stubs(:current_page?).returns(false)

    render "support/new_request_links", request_groups: Support::Requests::RequestGroups.new

    assert_select "ul.dropdown-menu li.active", 0
  end

  def test_rendering_of_feedex_link
    render "support/new_request_links", request_groups: Support::Requests::RequestGroups.new

    assert_select "#feedex", "Feedback explorer"
  end
end
