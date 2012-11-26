Support::Application.routes.draw do
  resource :content_change_request, :only => [:new, :create]
  resource :create_new_user_request, :only => [:new, :create]
  resource :remove_user_request, :only => [:new, :create]
  resource :general_request, :only => [:new, :create]
  resource :new_feature_request, :only => [:new, :create]

  match "campaign" => "support#campaign"
  match "acknowledge" => "support#acknowledge"
  root :to => 'support#landing'
end
