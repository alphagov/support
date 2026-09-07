Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount GovukAdminTemplate::Engine, at: "/style-guide", as: "style_guide"

  Support::Navigation::SectionGroups.new.all_request_class_names.each do |request_class_name|
    resource request_class_name.underscore, only: %i[new create]
  end

  get "/accounts_permissions_and_training_request/new" => redirect("/")

  namespace :anonymous_feedback do
    get :explore, to: "explore#new", format: false
    post :explore, to: "explore#create", format: false

    resources :organisations, only: :show, param: :slug, format: false
    resources :document_types, only: :show, param: :document_type, format: false

    resources :export_requests, only: %i[create show], format: false
    resources :global_export_requests, only: [:create], format: false

    resources :problem_reports, only: [:index] do
      put :review, on: :collection
    end
  end

  get "emergency-contact-details",
      to: "support#emergency_contact_details",
      format: false,
      as: "emergency_contact_details"

  resources :anonymous_feedback, only: %i[index create], format: false

  get "acknowledge" => "support#acknowledge"
  get "_status" => "support#queue_status"
  root to: "support#landing"

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response(
    GovukHealthcheck::RailsCache,
    GovukHealthcheck::SidekiqRedis,
  )

  namespace :content_advice, path: "content-advice" do
    get "/request-type", to: "request_type#new", as: :request_type
    post "/request-type", to: "request_type#create"

    get "/short-url", to: "short_url#new", as: :short_url
    post "/short-url", to: "short_url#create"

    get "/organisation-page", to: "organisation_page#new", as: :organisation_page
    post "/organisation-page", to: "organisation_page#create"

    get "/common_info", to: "common_info#new", as: :common_info
    post "/common_info", to: "common_info#create"

    get "/review", to: "review#index", as: :review

    post "/submit", to: "submission#create", as: :submission
  end
end
