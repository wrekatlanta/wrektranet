Wrek::Application.routes.draw do
  root to: "welcome#index"

  devise_for :users

  namespace :air do
    root to: "dashboard#index"

    resources :contests do
      resources :listener_tickets, shallow: true
    end

    resources :transmitter_log_entries do
      get 'unsigned', on: :collection
    end
    
    resources :psas do
      resources :psa_readings
    end
  end

  namespace :staff do
    root to: "dashboard#index"

    resources :staff_tickets, as: 'tickets' do
      collection do
        get 'me'
      end
    end

    resources :contest_suggestions
  end

  namespace :admin do
    root to: "dashboard#index"

    resources :contests do
      collection do
        get 'past', to: :index, defaults: { filter: 'past' }
      end
    end

    resources :psas do
      collection do
        get 'expired', to: :index, defaults: { filter: 'expired' }
      end
    end

    resources :transmitter_log_entries do
    end

    resources :venues
    resources :staff_tickets, as: 'tickets'
  end
end
