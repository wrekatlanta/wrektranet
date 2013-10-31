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
    Rails.env.development?
  end
end
