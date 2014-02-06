ContentManagement::Application.routes.draw do
  get "outgrader/all"
  post "outgrader/stats"
  resources :sites

  resources :links

  resources :contents do
    member do
      post 'add_link' => 'contents#add_link'
    end
  end

  root 'contents#index'
  
end
