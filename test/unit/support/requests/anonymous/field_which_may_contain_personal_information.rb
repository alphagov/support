require 'test_helper'
require 'support/requests/anonymous/field_which_may_contain_personal_information'

module Support
  module Requests
    module Anonymous
      def field_with(text)
        FieldWhichMayContainPersonalInformation.new(text)
      end

      class FieldWhichMayContainPersonalInformationTest < Test::Unit::TestCase
        should "not detect personal info when none is present" do
          refute field_with("abcde").include_personal_info?
        end

        should "notice when an email is present" do
          assert field_with("contact me at name@domain.com please").include_personal_info?
        end

        should "notice when a national insurance number is present" do
          assert field_with("QQ 12 34 56 A").include_personal_info?
          assert field_with("my NI number is QQ 12 34 56 A thanks").include_personal_info?
          assert field_with("QQ123456A").include_personal_info?
        end
      end
    end
  end
end
