ContentManagement::Application.routes.draw do
  get "stats/choose_dates"
  get "stats/results"
  devise_for :users

  get 'outgrader/get_redirect'
  get 'outgrader' => 'outgrader#index'
  get 'outgrader/start'
  get 'outgrader/stop'
  get 'outgrader/restart'
  get 'outgrader/kill'
  get 'outgrader/get_config'
  get 'outgrader/test'
  post 'outgrader/outgrader_change_ip'
  post 'outgrader/redirector_change_ip'
  post 'outgrader/change_config'

  get 'visits/send_click'
  post 'visits/send_click'
  get 'visits' => 'visits#index'
  get 'visits/send_visit'
  post 'visits/send_visit'

  resources :sites

  resources :links

  resources :contents do
    member do
      post 'add_link' => 'contents#add_link'
    end
  end

  root 'contents#index'

end
