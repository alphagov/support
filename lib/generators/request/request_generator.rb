require 'rails/generators'
require 'rails/generators/named_base'

class RequestGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def generate_model  
    template "request_template.rb.erb", "lib/support/requests/#{model_filename}.rb"
    template "request_test_template.rb.erb", "test/unit/support/requests/#{model_filename}_test.rb"
  end

  def generate_controller
    template "request_controller.rb.erb", "app/controllers/#{controller_filename}.rb"
  end

  def generate_zendesk_ticket_model
    template "zendesk_ticket_template.rb.erb", "lib/zendesk/ticket/#{zendesk_ticket_model_filename}.rb"
  end

  def generate_view
    template "new_view_template.html.erb", "app/views/#{view_folder_name}/new.html.erb"
    template "request_details_view_template.html.erb", "app/views/#{view_folder_name}/_request_details.html.erb"
  end

  def generate_cucumber_code
    template "cucumber.feature.erb", "features/#{view_folder_name}.feature"
    template "cucumber_steps.rb.erb", "features/step_definitions/#{view_folder_name}_steps.rb"
  end

  private
  def request_description
    "Some description of the request here"
  end

  def model_filename
    with_underscores(singular_name)
  end

  def model_class_name
    model_filename.classify
  end

  def controller_filename
    with_underscores((plural_name + " controller"))
  end

  def controller_class_name
    controller_filename.classify
  end

  def zendesk_ticket_model_filename
    with_underscores((singular_name + " ticket"))
  end

  def zendesk_ticket_model_class_name
    zendesk_ticket_model_filename.classify
  end

  def view_folder_name
    with_underscores(plural_name)
  end

  def with_underscores(str)
    str.gsub(" ", "_")
  end
end
