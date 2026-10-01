Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount GovukAdminTemplate::Engine, at: "/style-guide", as: "style_guide"

  resource :analytics_request, only: %i[new create]
  resource :campaign_request, only: %i[new create]
  resource :change_existing_user_request, only: %i[new create]
  resource :changes_to_publishing_apps_request, only: %i[new create]
  resource :content_advice_request, only: %i[new create]
  resource :content_change_request, only: %i[new create]
  resource :content_data_feedback, only: %i[new create]
  resource :create_new_user_or_training_request, only: %i[new create]
  resource :general_request, only: %i[new create]
  resource :live_campaign_request, only: %i[new create]
  resource :remove_user_request, only: %i[new create]
  resource :report_an_issue_with_govuk_search_results_request, only: %i[new create]
  resource :taxonomy_change_topic_request, only: %i[new create]
  resource :taxonomy_new_topic_request, only: %i[new create]
  resource :technical_fault_report, only: %i[new create]
  resource :unpublish_content_request, only: %i[new create]

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
end
