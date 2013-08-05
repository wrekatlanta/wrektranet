Wrek::Application.routes.draw do
  root :to => "welcome#index"

  devise_for :users

  namespace :admin do
    resources :contests, :venues
  end
end
