# WREKtranet 2.0

* [Setting up your development environment.](https://github.com/wrekatlanta/wrektranet-new/wiki/Setting-up-your-development-environment)
* [Need a Rails tutorial?](http://ruby.railstutorial.org/ruby-on-rails-tutorial-book)
* We use [Bootstrap](http://getbootstrap.com) on the front-end, if you're looking for classes to use.
* We use [Slim](http://slim-lang.com) for templating (ERB sucks). It's just HTML shorthand with other niceties.
* We use [SimpleForm](https://github.com/plataformatec/simple_form) for writing forms for its nicer syntax and Bootstrap integration.
* We use [CanCan](https://github.com/ryanb/cancan) for roles and permissions. Check the `ability.rb` file to see what our roles look like. If you're using the `create` method with *strong parameters*, [please read this](http://factore.ca/on-the-floor/258-rails-4-strong-parameters-and-cancan) to get around any issues.
