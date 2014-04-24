#require 'tail'

ContentManagement::Application.routes.draw do
  resources :video_files

  get "stats/choose_dates"
  get "stats/results"
  devise_for :users

  get 'redirector', to: 'outgrader#get_redirect', format: 'js'
  get 'outgrader/get_redirect'
  get 'outgrader' => 'outgrader#index'
  get 'outgrader/start'
  get 'outgrader/stop'
  get 'outgrader/restart'
  get 'outgrader/kill'
  get 'outgrader/get_config'
  post 'outgrader/outgrader_change_ip'
  post 'outgrader/redirector_change_ip'
  post 'outgrader/change_config'

  #get 'visits/send_click'
  post 'visits/send_click'
  get 'visits' => 'visits#index'
  #get 'visits/send_visit'
  post 'visits/send_visit'
  get 'visits/downloads'
  get 'visits/most_wanted'
  get 'visits/graph'
  get 'visits/torrents'


  mount Tail::Engine, at: '/tail'

  resources :sites

  resources :links

  resources :contents do
    member do
      post 'add_link' => 'contents#add_link'

    end
    collection do
      get 'create_with_kinopoisk' => 'contents#create_with_kinopoisk'
    end
  end

  root 'contents#index'

end
