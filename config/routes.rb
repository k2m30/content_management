ContentManagement::Application.routes.draw do
  devise_for :users
  get "outgrader/all"
  post "outgrader/stats"
  get "outgrader/get_redirect"
  get 'outgrader' => 'outgrader#index'
  get 'outgrader/start' => 'outgrader#start'
  get 'outgrader/stop' => 'outgrader#stop'
  get 'outgrader/restart' => 'outgrader#restart'
  get 'outgrader/kill' => 'outgrader#kill'
  get 'outgrader/get_config'
  get 'outgrader/test'
  post 'outgrader/outgrader_change_ip'
  post 'outgrader/redirector_change_ip'
  post 'outgrader/change_config'

  resources :sites

  resources :links

  resources :contents do
    member do
      post 'add_link' => 'contents#add_link'
    end
  end

  root 'contents#index'

end
