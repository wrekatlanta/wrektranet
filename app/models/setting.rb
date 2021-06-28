class Setting < RailsSettings::Base

  # Upgraded to newest rails settings
  field :contest_book_enabled, default: true
  field :transmitter_log_enabled, default: Rails.env.development?
  field :freehand_playlist_enabled, default: true
  field :live_playlist_enabled, default: true
  field :psa_book_enabled, default: true
  field :listener_log_enabled, default: true
  field :program_log_enabled, default: true
  field :calendar_enabled, default: true
  field :profiles_enabled, default: true
  field :transmitter_log_plate_curr_min, default: 0
  field :transmitter_log_plate_curr_max, default: 0
  field :transmitter_log_plate_volt_min, default: 0
  field :transmitter_log_plate_volt_max, default: 0
  field :transmitter_log_power_out_min, default: 0
  field :transmitter_log_power_out_max, default: 0

  end