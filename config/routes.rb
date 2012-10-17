Support::Application.routes.draw do
  match "amend-content" => "support#amend_content"
  match "create-user" => "support#create_user"
  match "acknowledge" => "support#acknowledge"
  root :to => 'support#landing'
end
