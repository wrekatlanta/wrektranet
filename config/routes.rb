Wrek::Application.routes.draw do
  root to: "welcome#index"

  devise_for :users, controllers: { registrations: "registrations" }

  resources :users do
    collection do
      get 'help'
      post 'reset_password'
      post 'fix_ldap'
    end
  end

  get 'auth/:user', to: 'authorization#authorizations', defaults: {format: :json}

  namespace :air do
    root to: "dashboard#index"

    resources :events, only: [:index]
    resources :program_log, only: [:index]
    resources :playlist, only: [:index]
    resources :albums, defaults: {format: :json}
    resources :play_logs, defaults: {format: :json} do
      member do
        post 'adjust_time'
      end
    end

    resources :contests do
      resources :listener_tickets, shallow: true
    end

    resources :transmitter_log_entries do
      collection do
        get 'unsigned'
        get 'archive'
      end
    end
    
    resources :psas do
      resources :psa_readings
    end
  end

  namespace :staff do
    root to: "dashboard#index"

    resources :users

    resources :pop_up_shows, only: [:index]

    resources :staff_tickets, as: 'tickets' do
      collection do
        get 'me'
      end
    end

    resources :listener_logs do
      collection do
        get 'hourly_averages'
        get 'current'
      end
    end

    resources :contest_suggestions
  end

  namespace :admin do
    root to: "dashboard#index"

    resources :settings

    resources :program_log_entries do
      resources :program_log_schedules, shallow: true
    end

    resources :calendars

    get 'contests/points'

    resources :contests do
      resources :staff_tickets, shallow: true
    end

    resources :psas do
      collection do
        get 'expired', to: :index, defaults: { filter: 'expired' }
      end
    end

    resources :transmitter_log_entries do
      collection do
        get 'unsigned'
      end
    end

    resources :users
    resources :venues
    resources :staff_tickets, as: 'tickets'
  end
end
