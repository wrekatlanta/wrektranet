Wrek::Application.routes.draw do
  root :to => "welcome#index"

  devise_for :users

  namespace :air do
    resources :contests do
      resources :listener_tickets, shallow: true
    end
  end

  namespace :staff do
    resources :staff_tickets
  end

  namespace :admin do
    resources :contests do
      collection do
        get 'past', to: :index, defaults: { filter: 'past' }
      end
    end

    resources :venues
  end
end
