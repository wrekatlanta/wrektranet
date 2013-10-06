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
11. Install nodejs as a JavaScript runtime: `sudo apt-get install nodejs`
13. `cd /vagrant/wrektranet-new` to get to the project directory.

More info on this Vagrant box: https://github.com/amaia/rails-starter-box

### Dependencies

1. `bundle` to install all the dependencies for this project.

### Database (with Vagrant-specific instructions)

1. Copy `config/database.yml.example` to `config/database.yml`.
2. `sudo -u postgres psql`
3. `\password vagrant`
4. Change the password for user *vagrant* in PostgreSQL.
5. Add username and password under `development` and `test` in `config/database.yml`.
6. Add `host: localhost` under `development` and `test`.
7. Add `template: template0` under `development` and `test`.

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
