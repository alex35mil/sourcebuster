# Sourcebuster

# Description

Sourcebuster tracks sources of your visitors.

It stores information about visitor's sources, handles sources overriding just like Google Analytics do and lets you store this info for further analysis.

## Setup

Add these lines to your application's `Gemfile`:

```ruby
gem 'sourcebuster', :git => "git@github.com:alexfedoseev/sourcebuster.git"
```

Add these lines to your application's `routes.rb`:

```ruby
mount Sourcebuster::Engine => "/sourcebuster"
```

Run in your shell:

```bash
bundle install
bundle exec rake sourcebuster:install:migrations
bundle exec rake db:migrate
```

And now allow to setup cookies by your application's `application_controller.rb`:

```ruby
class ApplicationController < ActionController::Base
  include Sourcebuster::CookieSettersHelper
  before_filter :set_sourcebuster_data
  helper_method :extract_sourcebuster_data

  # your code

  private

    def set_sourcebuster_data
      set_sourcebuster_cookies
    end

end
```

## Note on Patches/Pull Requests

* Fork [the project](https://github.com/alexfedoseev/sourcebuster).
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## License

MIT License, see the {file:LICENSE}.
