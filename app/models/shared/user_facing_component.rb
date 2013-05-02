require 'shared/tableless_model'

class UserFacingComponent < TablelessModel
  attr_accessor :name

  validates_presence_of :name
  validates :name, inclusion: { 
    in: %w(gov_uk mainstream_publisher travel_advice_publisher inside_government_publisher),
    message: "%{value} is not valid option"
  }

  def formatted_name
    Hash[options].key(name)
  end

  def inside_government_related?
    name == "inside_government_publisher"
  end

  def options
    [
      ["GOV.UK itself", "gov_uk"],
      ["Inside Government Publisher", "inside_government_publisher"],
      ["Mainstream Publisher", "mainstream_publisher"],
      ["Travel Advice Publisher", "travel_advice_publisher"],
    ]
  end
end
