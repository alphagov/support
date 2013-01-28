require 'request_groups'

Support::Application.routes.draw do
  RequestGroups.new.all_request_classes.each do |request_class|
    resource request_class.name.underscore, only: [:new, :create]
  end

  match "acknowledge" => "support#acknowledge"
  root to: 'support#landing'
end
