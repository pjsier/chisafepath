Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'

  get 'map' => 'home#map_page'
  get 'about' => 'home#about'

  get 'submitted' => 'home#submitted'
  post 'issue' => 'issue#create'

  post 'map_query' => 'issue#get_map_issues', :constraints => {:format=>:json}
  get 'json_issues' => 'issue#display_open_issues'

end
