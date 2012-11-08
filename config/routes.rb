Support::Application.routes.draw do
  resource :content_change_request, :only => [:new, :create]
  resource :create_new_user_request, :only => [:new, :create]
  resource :remove_user_request, :only => [:new, :create]

  match "campaign" => "support#campaign"
  match "general" => "support#general"
  match "publish-tool" => "support#publish_tool"
  match "acknowledge" => "support#acknowledge"
  root :to => 'support#landing'
end
