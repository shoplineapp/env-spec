# Env Spec

## Installation

```ruby
gem 'env-spec', git: 'https://github.com/shoplineapp/env-spec'
```

## Configuration

Create a yml file to specify environment variables used in the project with options  

Sample config file `config/env.yml`
```yml
raise_error: true
variables: # Environment variable name as key
  APP_HOST:
    required: true
  APP_MODE:
    required: true
    inclusion:
      - default
      - worker
  ID_CONVENTION:
    pattern: '[a-zA-Z0-9]{5}'
```

## Usage

Add following code into `config/application.rb` to validate environment variable on app start
```ruby
EnvSpec::Schema.new.validate!
```

or put following code into one of the step in CI/CD which will fail your test/deployment if environment variable is missing
```bash
RAILS_ENV=development bundle exec rails runner 'EnvSpec::Schema.new.validate!'
```

By default this Gem will use `config/env.yml` as the input configuration file  
In case you need to change it, specify `path` on initializing `EnvSpec::Schema`
```ruby
EnvSpec::Schema.new(path: "./config/env.yml")
```

## Tests

To run the test suite, first install the dependencies, then run `bundle exec rspec`:

```bash
$ bundle install
$ bundle exec rspec
```

## License

[MIT](LICENSE)