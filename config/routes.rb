Wrek::Application.routes.draw do
  root :to => "welcome#index"

  devise_for :users

  namespace :admin do
    resources :contests do
      collection do
        get 'past', to: :index, defaults: { filter: 'past' }
      end
    end

    resources :venues
  end
end
