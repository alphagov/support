require 'support/requests/request_groups'

Support::Application.routes.draw do
  Support::Requests::RequestGroups.new.all_request_class_names.each do |request_class_name|
    resource request_class_name.underscore, only: [:new, :create]
  end

  resource :foi_requests, only: :create

  match "acknowledge" => "support#acknowledge"
  match "_status" => "support#queue_status"
  root to: 'support#landing'
end
