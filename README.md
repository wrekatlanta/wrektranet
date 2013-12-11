# WREKtranet 2.0

## Getting Started

### System Pre-reqs

Make sure you have Ruby 2, Rails 4, and MySQL installed.

### Dependencies

1. `bundle` to install all the dependencies for this project.

### Database

1. Copy `config/database.yml.example` to `config/database.yml`.
2. For development and test, you can use:

```
development:
  adapter: mysql2
  database: wrektranet_development
  pool: 5
  host: localhost
```
  
and

```
test: &test
  adapter: mysql2
  database: wrek_test
  pool: 5
  host: localhost
```



Now you can run the commands to set the database up:

```bash
bundle exec rake db:create:all
bundle exec rake db:schema:load
bundle exec rake db:test:prepare
```

### Seed
1. Copy `config/application.yml.example` to `config/application.yml`.
2. Run `bundle exec rake db:seed`

Start the app with `rails server` and you are good to go. You can also run `guard` to watch for updates to tests and changes that require restarting the server.
