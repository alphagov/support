# frozen_string_literal: true

module Support
  module Requests
    module ContentAdvice
      class ShortUrlRequest < Support::Requests::ContentAdviceRequest
        attr_accessor :from_url, :to_url, :reason, :identity_proof, :gov_gateway_number, :email

        validates :from_url, :to_url, :reason, presence: true

        def title
          "Short URL Request"
        end

        def details
          "[type] Short URL request \n" \
            "[From URL] #{from_url}\n" \
            "[To URL] #{to_url}\n" \
            "[Reason] #{reason}\n" \
            "[Identity proof] #{identity_proof}\n" \
            "[Gov Gateway Number] #{gov_gateway_number}\n" \
            "[email] #{email}\n"
        end

        def self.link
          "/content_advice/short_url_request/new"
        end

        def self.label
          "Short URL Request"
        end

        def self.description
          "This is the description for the short url request form"
        end
      end
    end
  end
end
