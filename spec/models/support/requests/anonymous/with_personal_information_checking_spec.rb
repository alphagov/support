require 'rails_helper'
require 'active_model/model'
require 'support/requests/anonymous/with_personal_information_checking'

module Support
  module Requests
    module Anonymous
      class ContactWithFreeTextFields
        include ActiveModel::Model
        def self.scope(*args); end

        attr_accessor :free_text_field, :personal_information_status
        include WithPersonalInformationChecking
      end

      describe WithPersonalInformationChecking do
        def contact(options)
          ContactWithFreeTextFields.new(options).tap do |contact|
            contact.detect_personal_information_in(contact.free_text_field)
          end
        end

        it "doesn't detect personal info when none is present in free text fields" do
          expect(contact(free_text_field: "abc").personal_information_status).to eq("absent")
        end

        it "notices when an email is present in one of the free text fields" do
          expect(contact(free_text_field: "contact me at name@domain.com please").personal_information_status).to eq("suspected")
        end

        it "notices when a national insurance number is present in one of the free text fields" do
          expect(contact(free_text_field: "my NI number is QQ 12 34 56 A thanks").personal_information_status).to eq("suspected")
        end

        it "validates the personal_information_status field" do
          expect(contact(personal_information_status: nil)).to be_valid
          expect(contact(personal_information_status: "suspected")).to be_valid
          expect(contact(personal_information_status: "absent")).to be_valid

          expect(contact(personal_information_status: "abcde")).to_not be_valid
        end
      end
    end
  end
end
