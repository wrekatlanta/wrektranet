# WREKtranet 2.0

## Getting Started

# Vagrant

If you're not using the Rails Vagrant box, make sure you have Ruby 2, Rails 4, and PostgreSQL installed.

1. Install Vagrant and VirtualBox.
2. `git clone https://github.com/rails/rails-dev-box.git`
3. `cd rails-dev-box`
4. `git clone git@github.com:wrekatlanta/wrektranet-new.git`
5. Run `vagrant up` to set up the virtual machine.
6. Run `vagrant ssh` to ssh into your virtual machine.
7. `cd /vagrant/wrektranet-new` to get to the project directory.

### Dependencies

1. `bundle` to install all the dependencies for this project.

### Database

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

Start the app with `rails s` and you are good to go. You can also run `guard` to watch for updates to tests and changes that require restarting the server.
