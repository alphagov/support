require 'support/requests/anonymous/anonymous_contact'

module Support
  module Requests
    module Anonymous
      class ServiceFeedback < AnonymousContact
        attr_accessible :details, :slug, :service_satisfaction_rating, :url

        validates_presence_of :slug, :service_satisfaction_rating
        validates :details, length: { maximum: 2 ** 16 }
        validates_inclusion_of :service_satisfaction_rating, in: (1..5).to_a
        validates :url, url: true, length: { maximum: 2048 }, allow_nil: true

        def self.transaction_slugs
          uniq.pluck(:slug).sort
        end

        def self.aggregates_by_rating
          zero_defaults = Hash[*(1..5).map {|n| [n, 0] }.flatten]
          select("service_satisfaction_rating, count(*) as cnt").
            group(:service_satisfaction_rating).
            inject(zero_defaults) { |memo, result| memo[result[:service_satisfaction_rating]] = result[:cnt]; memo }
        end

        def self.with_comments_count
          where("details IS NOT NULL").count
        end
      end
    end
  end
end
