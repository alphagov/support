Support::Application.routes.draw do
  match "amend-content" => "support#amend_content"
  root :to => 'support#landing'
end
