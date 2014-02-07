# WREKtranet 2.0

This is [WREK](http://wrek.org)'s long-overdue new intranet. It provides tools that our radio DJs use on-air, for adminsitration, and for other purposes.

It's based on Rails 4, AngularJS, MySQL, and Bootstrap. Feel free to use parts of it or make contributions; other radio stations are welcome!

## Guides

* [Setting up your development environment.](https://github.com/wrekatlanta/wrektranet-new/wiki/Setting-up-your-development-environment)
* [Need a Rails tutorial?](http://ruby.railstutorial.org/ruby-on-rails-tutorial-book)
* [Application architecture overview.](https://github.com/wrekatlanta/wrektranet-new/wiki/Application-architecture-overview)

## Tools

### Front-end

* [Bootstrap](http://getbootstrap.com) on the front-end, if you're looking for classes to use.
* [Slim](http://slim-lang.com) for templating (ERB sucks). It's just HTML shorthand with other niceties.
* [SimpleForm](https://github.com/plataformatec/simple_form) for writing forms for its nicer syntax and Bootstrap integration.
* [AngularJS](http://angularjs.org) for interactive JavaScript pieces since it's more well-structured and powerful. This is totally optional, but if you see `ng-` in the HTML, that's what it is. `ng-init` is used on pageload to include JSON data in the templates instead of making a separate AJAX request when you first visit the page.
* [jQuery](http://jquery.com) is available if you really want to use it by itself... but try to keep things tidy.

### Authentication and authorization

* [Devise](https://github.com/plataformatec/devise) for user registration and authentication. In production, it hooks into our LDAP server.
* [CanCan](https://github.com/ryanb/cancan) for roles and permissions. Check the `ability.rb` file to see what our roles look like. If you're using the `create` method with **strong parameters**, [please read this](http://factore.ca/on-the-floor/258-rails-4-strong-parameters-and-cancan) to get around any issues.
* [Whenever](https://github.com/javan/whenever) for writing cron scripts with Ruby syntax and Rails-specific hooks.

### Testing

Mostly standard tools hee.

* RSPec for unit tests, or "specs."
* RSpec + Capybara (with a headless WebKit server through `poltergeist`) for integration tests.
* [factory_girl](https://github.com/thoughtbot/factory_girl) for creating test data in integration tests.

## Project Management and Communication

We use [Trello](https://trello.com/b/ccvdTsd5/wrektranet) for project management. We also have a Slack room and a special email address. Ask about 'em.
