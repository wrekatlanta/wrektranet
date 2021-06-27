class Setting < RailsSettings::Base
    def self.contest_book_enabled?
      true
    end

    def self.transmitter_log_enabled?
      Rails.env.development?
    end

    def self.live_playlist_enabled?
      true
    end

    def self.psa_book_enabled?
      true
    end

    def self.listener_log_enabled?
      true
    end

    def self.program_log_enabled?
      true
    end

    def self.calendar_enabled?
      true
    end

    def self.profiles_enabled?
      true
    end
  end