# [Lemur][gem_page]

[![Build Status][travis_status_image]][travis_page]
[![Maintainability][code_climate_maintainability_image]][code_climate_maintainability_page]
[![Test Coverage][code_climate_test_coverage_image]][code_climate_test_coverage_page]

A simple way to authenticate in APIs

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lemur', github: 'petlove/lemur'
```

and run:

```
rails lemur:install
```

## Settings
Set the settings in the file _config/initializers/lemur.rb_:

```ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'lemur'

DEFAULT_KEYS = %w[RAILS_ENV].freeze

Lemur.configure do |config|
  config.add_keys(DEFAULT_KEYS, true)
  # config.add_keys(STAGING_KEYS, ENV['APP_ENV'] == 'staging')
  # config.add_keys(PRODUCTION_KEYS, ENV['APP_ENV'] == 'production')
end

Lemur.check!

```

## Running the checker in a script

You can run the Lemur check in a bash script:

```bash
bash bin/lemur
```

## Using the checker in Codefresh pipelines

Append this code in your pipeline.yml:

```yml
check_envs:
  stage: build
  title: Checking required environments
  image: '${{build_docker_image}}'
  commands:
    - /app/bin/lemur
```

## Build Codefresh envs using Lemur

You can use Lemur to build your Codefresh Gems

First, create your `.env.lemur` files for each environment that you need with the header `# file:...`. This .env should be in your project root. For this example, the name is `.env.lemur.prod`:

```text
# file:codefresh/deployments/prod.yml

APP_TYPE=web
APP_ENV={{APP_ENV}}
AWS_ACCESS_KEY_ID='{{AWS_ACCESS_KEY_ID}}'
```

After create this file, you should run the builder task:

```bash
rails lemur:build_envs
```

So, the file `codefresh/deployments/prod.yml` was updated with the `.env.lemur.prod` environments.

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License][mit_license_page].

## Code of Conduct

Everyone interacting in the Rails::Healthcheck project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct][code_of_conduct_page].

[gem_page]: https://github.com/petlove/lemur
[code_of_conduct_page]: https://github.com/petlove/lemur/blob/master/CODE_OF_CONDUCT.md
[mit_license_page]: https://opensource.org/licenses/MIT
[contributor_convenant_page]: http://contributor-covenant.org
[travis_status_image]: https://travis-ci.org/petlove/lemur.svg?branch=master
[travis_page]: https://travis-ci.org/petlove/lemur
[code_climate_maintainability_image]: https://api.codeclimate.com/v1/badges/ea1e2ede7c154ce20546/maintainability
[code_climate_maintainability_page]: https://codeclimate.com/github/petlove/lemur/maintainability
[code_climate_test_coverage_image]: https://api.codeclimate.com/v1/badges/ea1e2ede7c154ce20546/test_coverage
[code_climate_test_coverage_page]: https://codeclimate.com/github/petlove/lemur/test_coverage