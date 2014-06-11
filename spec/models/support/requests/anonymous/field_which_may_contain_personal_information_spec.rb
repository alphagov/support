require 'rails_helper'
require 'support/requests/anonymous/field_which_may_contain_personal_information'

module Support
  module Requests
    module Anonymous
      describe FieldWhichMayContainPersonalInformation do
        def contains_personal_info?(text)
          FieldWhichMayContainPersonalInformation.new(text).include_personal_info?
        end

        it "doesn't detect personal info when none is present" do
          expect(contains_personal_info?("abcde")).to be_falsey
        end

        it "notices when an email is present" do
          expect(contains_personal_info?("contact me at name@domain.com please")).to be_truthy
        end

        it "notices when a national insurance number is present" do
          expect(contains_personal_info?("QQ 12 34 56 A")).to be_truthy
          expect(contains_personal_info?("my NI number is QQ 12 34 56 A thanks")).to be_truthy
          expect(contains_personal_info?("QQ123456A")).to be_truthy
        end
      end
    end
  end
end
