# WREKtranet 2.0

## Getting Started

# Checkout the repo

```bash
git clone git@github.com:wrekatlanta/wrektranet-new.git
```

### Install gem dependencies

```bash
gem install bundler
bundle install
```

### Install other dependencies

Install PostgreSQL on your development server.

### Setup the database

1. Copy `config/database.yml.example` to `config/database.yml`.
2. Under `development` and `test`, remove the lines for username and 
   password.
3. Add `host: localhost` under `development` and `test`.

Now you can run the commands to set the database up:

```bash
bundle exec rake db:create:all
bundle exec rake db:schema:load
bundle exec rake db:test:prepare
```

Now start the app and you are good to go. You can run `guard` to watch for updates to tests and changes that require restarting the server.