# frozen_string_literal: true

require 'fileutils'

SETTINGS = 'config/initializers/lemur.rb'
BIN = 'bin/lemur'

namespace :lemur do
  desc 'Install the environment checker'
  task :install do
    create_file(SETTINGS, initializer)
    create_file(BIN, bin)
  end
end

def create_file(path, content)
  FileUtils.mkdir_p(File.dirname(path))
  File.open(path, 'w') { |file| file << content }
end

def initializer
  <<~CONTENT
    # frozen_string_literal: true

    require 'lemur'

    DEFAULT_KEYS = %w[RAILS_ENV]

    Lemur.configure do |config|
      config.add_keys(DEFAULT_KEYS, true)
      # config.add_keys(STAGING_KEYS, ENV['APP_ENV'] == 'staging')
      # config.add_keys(PRODUCTION_KEYS, ENV['APP_ENV'] == 'production')
    end

    Lemur.check!
  CONTENT
end

def bin
  <<~CONTENT
    #!/usr/bin/env bash
    set -e

    ruby config/initializers/lemur.rb
  CONTENT
end