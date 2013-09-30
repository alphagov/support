require 'support/requests/request_groups'

Support::Application.routes.draw do
  Support::Requests::RequestGroups.new.all_request_class_names.each do |request_class_name|
    resource request_class_name.underscore, only: [:new, :create]
  end

  resource :foi_requests, only: :create
  resource :named_contacts, only: :create

  namespace :anonymous_feedback do
    resource :problem_reports, only: :create
  end

  match "acknowledge" => "support#acknowledge"
  match "_status" => "support#queue_status"
  root to: 'support#landing'
end
