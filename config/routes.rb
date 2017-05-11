require 'support/navigation/section_groups'

Rails.application.routes.draw do
  mount GovukAdminTemplate::Engine, at: "/style-guide", as: "style_guide"

  Support::Navigation::SectionGroups.new.all_request_class_names.each do |request_class_name|
    resource request_class_name.underscore, only: [:new, :create]
  end

  resources :foi_requests, only: :create
  resources :named_contacts, only: :create

  namespace :anonymous_feedback do
    get :explore, to: "explore#new", format: false
    post :explore, to: "explore#create", format: false

    resources :organisations, only: :show, param: :slug, format: false

    resources :export_requests, only: [:create, :show], format: false
    resources :global_export_requests, only: [:create], format: false

    resources :problem_reports, only: [:index] do
      put :review, on: :collection
    end
  end

  get "emergency-contact-details",
    to: 'support#emergency_contact_details',
    format: false,
    as: "emergency_contact_details"

  resources :anonymous_feedback, only: :index, format: false

  get "acknowledge" => "support#acknowledge"
  get "_status" => "support#queue_status"
  root to: 'support#landing'
end
