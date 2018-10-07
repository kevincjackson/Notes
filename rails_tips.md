# Rails Conf 2017 Tips & Tricks by David Padilla

## Separate Strings / Integers
1. to a constant
2. to config file

Bad
```ruby
  5.minutes ago
```
Good
```ruby
  TIME_LIMIT = 5
  TIME_LIMIT.minutes ago
```

## Separate Data Migrations
1. Prefer SQL over Ruby (faster, won't fail on nil)
2. Use a data migration gem

## Background Jobs
1. Pass id's not objects b/c they're converted to YAML
2. Always deliver email later & use id's not objects

## Be Restful
1. Only use REST verbs :show, :new, :create, :edit :update, :delete

Bad
```ruby
# Model
class ProductsController < ApplicationController
  def deactivate
    # ...
  end
end

# Routes
resources :products do
  get :deactivate
end
```
Good
```ruby
# Model
class ProductStatesController < ApplicationController
  def update
    # ...
  end
end

# Routes
resources :products do
  resource :status, :only => :update
end
```

Bad
```ruby
# Model
class ContactsController < ApplicationController
  def search
    # ...
  end
end

# Routes
resources :contacts do
  get :search
end
```

Good
```ruby
# Model
class Contacts::SearchesController < ApplicationController
  def show
    # ..
  end
end

# Routes
resources :contacts
namespace :contacts do
  resource :search, :only => :show
end

```

## Must-Use Gems 
1. Rubocop
2. Annotate
3. Bullet
4. Oink

### Rubocop
Checks code quality.

```
# generate TODO exceptions if there's going to be too many errors
rubocop --auto-gen-config

# Rubocop.yml
Style/Documentations
  Enabled: false

# Build rubocop into your build.
  # .git/hooks/pre-push

  #!/bin/bash
  rubocop
```
### Annotate Gem
Adds schema info to models.   

Use `annotate --routes` annotates routes

### Bullet
Detects the n+1 query problems

### Oink
Detects memory leaks.  
Use in development only.
