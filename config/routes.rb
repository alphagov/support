require 'support/requests/request_groups'

Support::Application.routes.draw do
  Support::Requests::RequestGroups.new.all_request_class_names.each do |request_class_name|
    resource request_class_name.underscore, only: [:new, :create]
  end

  resources :foi_requests, only: :create
  resources :named_contacts, only: :create

  namespace :anonymous_feedback do
    resources :problem_reports, only: FEEDEX_ENABLED ? [ :create, :index ] : [ :create ], format: false
    resources :long_form_contacts, only: :create
    resources :service_feedback, only: :create

    if FEEDEX_ENABLED
      namespace :problem_reports do
        get :explore, to: "explore#new", format: false
        post :explore, to: "explore#create", format: false
      end
    end
  end

  match "acknowledge" => "support#acknowledge"
  match "_status" => "support#queue_status"
  root to: 'support#landing'
end
