Rails.application.routes.draw do
  root 'invite#index'

  post '/submit' => 'invite#submit'
  get '/submit' => 'invite#submit' # for people that manually refresh in the address bar after entering something invalid
end
