Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'

  get 'map' => 'home#map_page'
  get 'about' => 'home#about'
  get 'routing' => 'home#routing'
  get 'issue' => 'home#issue'

  get 'submitted' => 'home#submitted'
  post 'issue' => 'issue#api_submit'

  post 'map_query' => 'issue#get_map_issues', :constraints => {:format=>:json}
  get 'all_issues' => 'issue#all_open_issues'
end
