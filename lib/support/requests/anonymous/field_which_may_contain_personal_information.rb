module Support
  module Requests
    module Anonymous
      class FieldWhichMayContainPersonalInformation
        NATIONAL_INSURANCE_NUMBER_PATTERN = /[a-zA-Z]{2}[0-9]{6}[a-zA-Z]{1}/
        EMAIL_ADDRESS_PATTERN = /@/

        def initialize(text)
          @text = text
        end

        def include_personal_info?
          include_email_address? or include_national_insurance_number?
        end

        private
        def include_email_address?
          not @text.nil? and @text =~ EMAIL_ADDRESS_PATTERN
        end

        def include_national_insurance_number?
          not @text.nil? and @text.gsub(/\s/, '') =~ NATIONAL_INSURANCE_NUMBER_PATTERN
        end
      end
    end
  end
end
