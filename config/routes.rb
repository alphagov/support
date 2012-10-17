Support::Application.routes.draw do
  match "amend-content" => "support#amend_content"
  match "acknowledge" => "support#acknowledge"
  root :to => 'support#landing'
end
