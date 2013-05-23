require 'request_groups'

Support::Application.routes.draw do
  RequestGroups.new.all_request_class_names.each do |request_class_name|
    resource request_class_name.underscore, only: [:new, :create]
  end

  match "acknowledge" => "support#acknowledge"
  root to: 'support#landing'
end
