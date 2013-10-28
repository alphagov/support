require 'test_helper'
require 'support/requests/anonymous/anonymous_contact'

class TestContact < Support::Requests::Anonymous::AnonymousContact
  attr_accessible :details, :what_wrong, :what_doing
end

module Support
  module Requests
    module Anonymous
      class AnonymousContactTest < Test::Unit::TestCase
        def new_contact(options)
          defaults = { javascript_enabled: true }
          TestContact.new(defaults.merge(options))
        end

        def contact(options)
          new_contact(options).tap { |c| c.save! }
        end

        should "not detect personal info when none is present in free text fields" do
          assert_equal "absent", contact(details: "abc", what_wrong: "abc", what_doing: "abc").personal_information_status
        end

        should "notice when an email is present in one of the free text fields" do
          assert_equal "suspected", contact(details: "contact me at name@domain.com please").personal_information_status
          assert_equal "suspected", contact(what_doing: "contact me at name@domain.com please").personal_information_status
          assert_equal "suspected", contact(what_wrong: "contact me at name@domain.com please").personal_information_status
        end

        should "notice when a national insurance number is present in one of the free text fields" do
          assert_equal "suspected", contact(details: "my NI number is QQ 12 34 56 A thanks").personal_information_status
          assert_equal "suspected", contact(what_doing: "my NI number is QQ 12 34 56 A thanks").personal_information_status
          assert_equal "suspected", contact(what_wrong: "my NI number is QQ 12 34 56 A thanks").personal_information_status
        end

        should "validate the personal_information_status field" do
          assert new_contact(personal_information_status: nil).valid?
          assert new_contact(personal_information_status: "suspected").valid?
          assert new_contact(personal_information_status: "absent").valid?

          refute new_contact(personal_information_status: "abcde").valid?
        end
      end
    end
  end
end
