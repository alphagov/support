require 'support/navigation/section_groups'

Support::Application.routes.draw do
  mount GovukAdminTemplate::Engine, at: "/style-guide", as: "style_guide"

  Support::Navigation::SectionGroups.new.all_request_class_names.each do |request_class_name|
    resource request_class_name.underscore, only: [:new, :create]
  end

  resources :foi_requests, only: :create
  resources :named_contacts, only: :create

  namespace :anonymous_feedback do
    resources :problem_reports, only: :create, format: false
    resources :long_form_contacts, only: :create
    resources :service_feedback, only: :create

    get 'problem_reports', to: redirect {|p, req| req.params[:path] ? "/anonymous_feedback?path=" + req.params[:path] : "/anonymous_feedback"}

    namespace :problem_reports do
      get :explore, to: redirect("/anonymous_feedback/explore"), format: false
    end

    get :explore, to: "explore#new", format: false
    post :explore, to: "explore#create", format: false
  end

  resources :anonymous_feedback, only: :index, format: false

  match "acknowledge" => "support#acknowledge"
  match "_status" => "support#queue_status"
  root to: 'support#landing'
end
