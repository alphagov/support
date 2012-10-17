Support::Application.routes.draw do
  match "amend-content" => "support#amend_content"
  # root :to => 'welcome#index'
end
