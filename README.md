# Configuration::Helper

Configuration::Helper is just a collection of configuration helpers I tend to use for Rails app when setting up Redis, Memcached, Sidekiq etc.

It relies on the new Rails 5.2 credentials feature where it expects to find the relevant connection details / settings.

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
    pool_size: "55" # Needs to be more than the pool size for Sidekiq
    session_key: "_app_session"
    password: "" # If password is set, it has to end with @ for string concatenation to work properly
    namespace: "app_namespace"
    namespace_environments: "development,test" # Namespacing will only be enabled for the defined environments, namespacing is not recommended for production use
    session_database: "0"
    sidekiq_database: "1"
    action_cable_database: "2"
    cache_database: "3"
  
  memcached:
    host: "localhost"
    port: "11211"
    pool_size: "55"
    namespace: "app_namespace"
    session_key: "_app_session"
  
  sidekiq:
    web:
      username: "admin"
      password: "admin"
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
