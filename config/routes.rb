Support::Application.routes.draw do
  resource :content_change_request, :only => [:new, :create]

  match "create-user" => "support#create_user"
  match "remove-user" => "support#remove_user"
  match "campaign" => "support#campaign"
  match "general" => "support#general"
  match "publish-tool" => "support#publish_tool"
  match "acknowledge" => "support#acknowledge"
  root :to => 'support#landing'
end
