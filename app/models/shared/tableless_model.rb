class TablelessModel
  include ActiveModel::Validations
  include ActiveModel::Conversion  
  extend ActiveModel::Naming

  def initialize(attributes = {})
    attributes.each do |key, value|
      if respond_to? "#{key}="
        send("#{key}=", value)
      end
    end
  end

  def persisted?  
    false  
  end
end