module Settings
  def self.contest_book_enabled?
    true
  end

  def self.transmitter_log_enabled?
    Rails.env.development?
  end

  def self.psa_book_enabled?
    Rails.env.development?
  end

  def self.listener_log_enabled?
    true
  end

  def self.calendar_enabled?
    ENV.has_key? 'EVENT_CALENDAR_ID'
  end

  def self.profiles_enabled?
    Rails.env.development?
  end
end
