Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'guest#search'
  post '/history' => 'guest#player_history'
  get '/history' => 'guest#player_history'
  get '/analytics' => 'guest#analytics_match'
  get '/current' => 'guest#current_match'
end
