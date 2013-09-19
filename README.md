# WREKtranet 2.0

## Getting Started

### Vagrant

If you're not using the Rails Vagrant box, make sure you have Ruby 2, Rails 4, and PostgreSQL installed.

1. Install Vagrant and VirtualBox.
2. `git clone https://github.com/amaia/rails-starter-box`
3. `cd rails-starter-box`
4. `git submodule init`
5. `git submodule update`
6. `git clone git@github.com:wrekatlanta/wrektranet-new.git`
7. Run `vagrant up` to set up the virtual machine.
8. Run `vagrant ssh` to ssh into your virtual machine.
9. Upgrade to Ruby 2.0 by running: `rvm install 2.0.0 && rvm --default use 2.0.0`
10. `cd /vagrant/wrektranet-new` to get to the project directory.

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

Start the app with `rails server` and you are good to go. You can also run `guard` to watch for updates to tests and changes that require restarting the server.
