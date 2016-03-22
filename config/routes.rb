Rails.application.routes.draw do


  root 'invite#index'

  post '/submit' => 'invite#submit'

  get '/support' => 'support#index'
  get '/privacy' => 'privacy#index'
end
