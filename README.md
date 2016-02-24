# ActionBouncer

[![Circle CI](https://circleci.com/gh/oswaldoferreira/action_bouncer/tree/master.svg?style=svg)](https://circleci.com/gh/oswaldoferreira/action_bouncer/tree/master)

It's a dead simple Rails authorization lib for well defined authorization objects interfaces.

## Installing

Add it to your gemfile:

`gem 'action_bouncer'`

Or manually install it:

`gem install action_bouncer`

## Examples

Allowing user to access specific actions:

```ruby
class UsersController < ApplicationController
  allow :current_user, to: [:index, :new], if: :admin?

  def index
  end

  def new
  end
  
  def edit
  end
end
```

Allowing user to access all actions:

```ruby
class UsersController < ApplicationController
  allow :current_user, to: :all, if: :admin?

  def index
  end

  def new
  end
  
  def edit
  end
end
```

Also, you can pass multiple methods that your authorizable object responds to:

```ruby
allow :current_user, to: [:index, :new], if: [:admin?, :leader?]
```

When not authorized, `ActionBouncer` raises an exception that can be rescued on your `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  include ActionBouncer

  rescue_from ActionBouncer::Unauthorized,
    with: :user_not_authorized

  private

  def user_not_authorized
    render nothing: true, status: :unauthorized
  end
end
```

## Development

```
bundle install
bundle exec rspec spec
```

Feel free to create issues and submit pull requests.
