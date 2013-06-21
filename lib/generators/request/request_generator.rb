require 'rails/generators'
require 'rails/generators/named_base'

class RequestGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  argument :request_description, type: :string, required: false

  def generate_model  
    template "request_template.rb.erb", "lib/support/requests/#{model_filename}.rb"
    template "request_test_template.rb.erb", "test/unit/support/requests/#{model_filename}_test.rb"
  end

  private  
  def model_filename
    name.underscore + "_request"
  end

  def model_class_name
    model_filename.classify
  end
end
