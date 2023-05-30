module Support
  module GDS
    class UserFacingComponents
      class << self
        def all
          component_options.map do |options|
            UserFacingComponent.new(options)
          end
        end

        def find(attributes)
          all.detect { |component| component.id == attributes["name"] }
        end

      protected

        def component_options
          [
            { name: "Collections Publisher", id: "collections_publisher" },
            { name: "Contacts Admin", id: "contacts_admin" },
            { name: "Content Data", id: "content_data" },
            { name: "Content Publisher (beta)", id: "content_publisher" },
            { name: "Content Tagger", id: "content_tagger" },
            { name: "data.gov.uk", id: "datagovuk" },
            { name: "GOV.UK: content", id: "gov_uk_content" },
            { name: "Imminence", id: "imminence" },
            { name: "Local Links Manager", id: "local_links_manager" },
            { name: "Mainstream Publisher", id: "mainstream_publisher" },
            { name: "Manuals Publisher", id: "manuals_publisher" },
            { name: "Maslow", id: "maslow" },
            { name: "Service Manual Publisher", id: "service_manual_publisher" },
            { name: "Short URL Manager", id: "short_url_manager" },
            { name: "Signon", id: "signon" },
            { name: "Specialist Publisher", id: "specialist_publisher" },
            { name: "Travel Advice Publisher", id: "travel_advice_publisher" },
            { name: "Whitehall Publisher", id: "inside_government_publisher", inside_government_related: true },
          ]
        end
      end
    end
  end
end
