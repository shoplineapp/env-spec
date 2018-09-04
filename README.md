# Env Spec

[![CircleCI](https://circleci.com/gh/shoplineapp/env-spec/tree/master.svg?style=shield)](https://circleci.com/gh/shoplineapp/env-spec/tree/master)
[![Coverage Status](https://coveralls.io/repos/github/shoplineapp/env-spec/badge.svg?branch=master)](https://coveralls.io/github/shoplineapp/env-spec?branch=master)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/f8b92add19c249c29650997cebaace5b)](https://www.codacy.com/app/shoplineapp/env-spec?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=shoplineapp/env-spec&amp;utm_campaign=Badge_Grade)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

## Installation

```ruby
gem 'env-spec', git: 'https://github.com/shoplineapp/env-spec'
```

## Configuration

Create a yml file to specify environment variables used in the project with specification with generator  
```bash
rails generate env_spec:create_config_file
```
By default the generator will grep environment variable usage from `app`, `config` and `lib` folders and add them into the specification with `required: false`. You might check `config/env.yml` and update setting for each environment variables  

EnvSpec provide following attributes for each environment variable

| Option | Description |
| --- | --- |
| description | Short usage summary of the variable |
| required | Specify if the variable is required |
| inclusion | Validate value with specified values in array |
| pattern | Validate value with regex |

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
