namespace :import do
  require 'nokogiri'
  require 'open-uri'

  task :users => [:environment] do
    doc = Nokogiri::HTML(open("http://wrektranet.wrek.org/staff/printablelist.php3"))

    client = GoogleAppsHelper.create_client
    directory = client.discovered_api('admin', 'directory_v1')
    batch = Google::APIClient::BatchRequest.new

    doc.css('tr:not(:first-child)').each do |row|
      first_name = row.css('td:nth-child(1)')[0].content
      last_name = row.css('td:nth-child(2)')[0].content
      phone = row.css('td:nth-child(3)')[0].content
      email = row.css('td:nth-child(4)')[0].content
      initials = row.css('td:nth-child(5)')[0].content.downcase

      unless User.find_by(username: initials)
        password = Devise.friendly_token[0,20]

        user = User.create!({
          email: email,
          username: initials,
          first_name: first_name,
          last_name: last_name,
          password: password,
          phone: phone
        })

        batch.add(api_method: directory.users.insert,
          body_object: {
            name: {
              familyName: last_name,
              givenName: first_name
            },
            password: password,
            primaryEmail: initials + '@wrek.org',
            phones: [
              {
                primary: true,
                type: "mobile",
                value: phone
              }
            ]
          }
        )

        puts "created #{initials} with password #{password}"

        UserMailer.import_email(user, password, email).deliver
      end
    end

    client.execute(batch)

    f.close
  end
end