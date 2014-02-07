# WREKtranet 2.0

This is [WREK](http://wrek.org)'s long-overdue new intranet. It provides tools that our radio DJs use on-air, for adminsitration, and for other purposes.

It's based on Rails 4, AngularJS, MySQL, and Bootstrap. Feel free to use parts of it or make contributions; other radio stations are welcome!

* [Setting up your development environment.](https://github.com/wrekatlanta/wrektranet-new/wiki/Setting-up-your-development-environment)
* [Need a Rails tutorial?](http://ruby.railstutorial.org/ruby-on-rails-tutorial-book)
* [Application architecture overview.](https://github.com/wrekatlanta/wrektranet-new/wiki/Application-architecture-overview)
* We use [Bootstrap](http://getbootstrap.com) on the front-end, if you're looking for classes to use.
* We use [Slim](http://slim-lang.com) for templating (ERB sucks). It's just HTML shorthand with other niceties.
* We use [SimpleForm](https://github.com/plataformatec/simple_form) for writing forms for its nicer syntax and Bootstrap integration.
* We use [Devise](https://github.com/plataformatec/devise) for user registration and authentication. In production, it hooks into our LDAP server.
* We use [CanCan](https://github.com/ryanb/cancan) for roles and permissions. Check the `ability.rb` file to see what our roles look like. If you're using the `create` method with **strong parameters**, [please read this](http://factore.ca/on-the-floor/258-rails-4-strong-parameters-and-cancan) to get around any issues.
* We generally use [AngularJS](http://angularjs.org) for interactive JavaScript pieces since it's more well-structured and powerful. This is totally optional, but if you see `ng-` in the HTML, that's what it is.
* We use [Whenever](https://github.com/javan/whenever) for writing cron scripts with Ruby syntax and Rails-specific hooks.
* We use RSPec for unit tests ("specs"), RSpec + Capybara (with a headless WebKit server through `poltergeist`) for integration tests, and [factory_girl](https://github.com/thoughtbot/factory_girl) for creating test data in integration tests. Mostly standard tools here.
