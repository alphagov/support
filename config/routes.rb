Support::Application.routes.draw do
  match "amend-content" => "support#amend_content"
  match "create-user" => "support#create_user"
  match "remove-user" => "support#remove_user"
  match "campaign" => "support#campaign"
  match "general" => "support#general"
  match "publish-tool" => "support#publish_tool"
  match "acknowledge" => "support#acknowledge"
  root :to => 'support#landing'
end
