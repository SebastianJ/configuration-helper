# Configuration::Helper

Configuration::Helper is just a collection of configuration helpers I tend to use for Rails app when setting up Redis, Memcached, Sidekiq etc.

It relies on the new Rails 5.2+ credentials feature where it expects to find the relevant connection details / settings.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'configuration-helper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install configuration-helper

## Usage

Your config/credentials.yml.enc file is expected to have a structure similar to the following:

```yaml
development:
  redis:
    host: "localhost"
    port: "6379"
    pool_size: "55" # If Sidekiq is going to be used, this setting needs to be set higher than the concurrency setting in config/sidekiq.yml
    session_key: "_app_session"
    password: "" # If password is set, it has to end with @ for string concatenation to work properly
    session_database: "0"
    sidekiq_database: "1"
    action_cable_database: "2"
    cache_database: "3"
  
  memcached:
    host: "localhost"
    port: "11211"
    pool_size: "55" # If Sidekiq is going to be used, this setting needs to be set higher than the concurrency setting in config/sidekiq.yml
    namespace: "app_namespace"
    session_key: "_app_session"
```

### Redis configuration
To configure Redis to be used for sessions + job storage for Sidekiq:

Create an initializer, e.g. config/initializers/redis.rb:

```ruby
::Configuration::Helper::Redis.configure_sessions
::Configuration::Helper::Redis.configure_sidekiq
```

### Memcached configuration
If you want to use Memcached for caching then the caching setup needs to happen in config/environments/{environment}.rb

If done via an initializer Rails won't set up the caching functionality properly.

For each environment where caching using Memcached should be used:

```ruby
Rails.application.config.cache_store = :dalli_store, ::Configuration::Helper::Memcached.config_variable(:host), ::Configuration::Helper::Memcached.generate_cache_configuration
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SebastianJ/configuration-helper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Configuration::Helper project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/SebastianJ/configuration-helper/blob/master/CODE_OF_CONDUCT.md).
