module Support
  module GDS
    class UserFacingComponents
      class << self
        def all
          Support::Requests::TechnicalFaultReport::OPTIONS.map do |key, value|
            UserFacingComponent.new({ name: value, id: key })
          end
        end

        def find(attributes)
          all.detect { |component| component.id == attributes["name"] }
        end
      end
    end
  end
end
