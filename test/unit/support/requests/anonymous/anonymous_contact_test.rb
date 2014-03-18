require 'test_helper'
require 'support/requests/anonymous/anonymous_contact'

class TestContact < Support::Requests::Anonymous::AnonymousContact
  attr_accessible :details, :what_wrong, :what_doing, :url
end

module Support
  module Requests
    module Anonymous
      class AnonymousContactTest < Test::Unit::TestCase
        DEFAULTS = { javascript_enabled: true, url: "https://www.gov.uk/tax-disc" }

        def new_contact(options = {})
          TestContact.new(DEFAULTS.merge(options))
        end

        def contact(options = {})
          new_contact(options).tap { |c| c.save! }
        end

        def path_for(url)
          URI(url).path
        end

        should "enforce the presence of a reason why feedback isn't actionable" do
          contact = new_contact(is_actionable: false, reason_why_not_actionable: "")
          refute contact.valid?
          refute contact.errors[:reason_why_not_actionable].empty?
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

        context "URLs" do
          should allow_value("https://www.gov.uk/something").for(:url)
          should allow_value(nil).for(:url)
          should allow_value("http://" + ("a" * 2040)).for(:url)
          should_not allow_value("http://" + ("a" * 2050)).for(:url)
          should_not allow_value("http://bla.example.org:9292/méh/fào?bar").for(:url)
        end

        should "mark duplicates as non-actionable" do
          contact = new_contact
          contact.mark_as_duplicate

          refute contact.is_actionable
          assert_equal "duplicate", contact.reason_why_not_actionable
        end

        context "#find_all_starting_with_path" do
          should "find urls beginning with the given path" do
            a = contact(url: "https://www.gov.uk/some-calculator/y/abc")
            b = contact(url: "https://www.gov.uk/some-calculator/y/abc/x")
            c = contact(url: "https://www.gov.uk/tax-disc")

            result = TestContact.find_all_starting_with_path("/some-calculator")

            assert_equal 2, result.size
            assert result.include?(a)
            assert result.include?(b)
          end

          should "return the results in reverse chronological order" do
            a, b, c = contact, contact, contact
            a.created_at = Time.now - 1.hour
            b.created_at = Time.now - 2.hour
            c.created_at = Time.now
            [a, b, c].map(&:save)

            assert_equal [c, a, b], TestContact.find_all_starting_with_path(path_for(DEFAULTS[:url]))
          end

          should "only return reports with no known personal information" do
            a = contact(personal_information_status: "absent")
            _ = contact(personal_information_status: "suspected")

            assert_equal [a], TestContact.find_all_starting_with_path(path_for(DEFAULTS[:url]))
          end

          should "only return actionable feedback" do
            a = contact(is_actionable: true)
            _ = contact(is_actionable: false, reason_why_not_actionable: "spam")

            assert_equal [a], TestContact.find_all_starting_with_path(path_for(DEFAULTS[:url]))
          end

          def teardown
            TestContact.delete_all
          end
        end

        context "#deduplicate_contacts_created_between" do
          should "update contacts created in the given interval as they are marked as dupes" do
            interval = mock("some time interval")
            original_contact = mock("anonymous contact")
            duplicate = mock("anonymous contact")
            contacts = [ original_contact, duplicate ]

            AnonymousContact.expects(:where).with(created_at: interval).returns(stub(order: contacts))
            DuplicateDetector.any_instance.stubs(:duplicate?).with(original_contact).returns(false)
            DuplicateDetector.any_instance.stubs(:duplicate?).with(duplicate).returns(true)

            duplicate.expects(:mark_as_duplicate)
            duplicate.expects(:save!)

            AnonymousContact.deduplicate_contacts_created_between(interval)
          end
        end
      end
    end
  end
end
