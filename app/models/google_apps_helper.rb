module GoogleAppsHelper
  require 'google/api_client'
  require 'google/api_client/client_secrets'
  require 'google/api_client/auth/installed_app'

  def self.create_client
    # Initialize the client.
    @@client ||= Google::APIClient.new(
      :application_name => 'WREKtranet',
      :application_version => '0.0.1'
    )

    @@key ||= OpenSSL::PKey::RSA.new(ENV["GOOGLE_APPS_KEY"], 'notasecret')

    @@client.authorization = Signet::OAuth2::Client.new(
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      audience: 'https://accounts.google.com/o/oauth2/token',
      scope: ['https://www.googleapis.com/auth/admin.directory.user'],
      issuer: '248139186331-h4co97r8ual8pt0eimsm75kfr66petsp@developer.gserviceaccount.com',
      signing_key: @@key,
      person: 'pstoic@wrek.org'
    )

    @@client.authorization.fetch_access_token!

    return @@client
  end
end