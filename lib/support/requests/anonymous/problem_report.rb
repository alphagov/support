require 'uri'
require 'support/requests/anonymous/anonymous_contact'

module Support
  module Requests
    module Anonymous
      class ProblemReport < AnonymousContact
        attr_accessible :what_doing, :what_wrong, :url, :source, :page_owner

        validates :url, :referrer, url: true, allow_nil: true
        validates :url, length: { maximum: 2048 }

        validates :what_doing, length: { maximum: 2 ** 16 }
        validates :what_wrong, length: { maximum: 2 ** 16 }

        def path
          URI(url).path
        end

        def referrer_url_on_gov_uk?
          referrer and URI.parse(referrer).host == "www.gov.uk"
        end

        def self.find_all_starting_with_path(path)
          where("url like ?", "%" + path + "%").free_of_personal_info.order("created_at desc").select { |pr| pr.path.start_with?(path) }
        end
      end
    end
  end
end
