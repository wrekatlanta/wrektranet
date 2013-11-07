Wrek::Application.routes.draw do
  root to: "welcome#index"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks",
                                    registrations: "registrations" }

  namespace :air do
    root to: "dashboard#index"

    resources :events, only: [:index]

    resources :contests do
      resources :listener_tickets, shallow: true
    end

    resources :transmitter_log_entries do
      collection do
        get 'unsigned'
      end
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

    resources :listener_logs do
      collection do
        get 'current'
      end
    end

    resources :contest_suggestions
  end

  namespace :admin do
    root to: "dashboard#index"

    resources :program_log_entries

    resources :program_log_entry_schedules

    resources :contests do
      resources :staff_tickets, shallow: true
    end

    resources :psas do
      collection do
        get 'expired', to: :index, defaults: { filter: 'expired' }
      end
    end

    resources :transmitter_log_entries do
    end

    resources :users
    resources :venues
    resources :staff_tickets, as: 'tickets'
  end
end
