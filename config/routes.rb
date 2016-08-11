Rails.application.routes.draw do
  get 'manage/external'
  delete 'manage/external/:id' => 'manage#delete'
  post 'manage/renew/external/:id' =>  'manage#renew'

  root 'invite#index'

  post '/submit' => 'invite#submit'
end
