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
            { name: "GOV.UK: content", id: "gov_uk_content" },
            { name: "Whitehall Publisher", id: "inside_government_publisher", inside_government_related: true },
            { name: "Mainstream Publisher", id: "mainstream_publisher" },
            { name: "Travel Advice Publisher", id: "travel_advice_publisher" },
            { name: "Specialist Publisher", id: "specialist_publisher" },
          ]
        end
      end
    end
  end
end
