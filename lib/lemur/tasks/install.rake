# frozen_string_literal: true

require 'fileutils'

SETTINGS = 'config/initializers/lemur.rb'

namespace :lemur do
  desc 'Install the environment checker'
  task :install do
    create_initializer
  end
end

def create_initializer
  FileUtils.mkdir_p(File.dirname(SETTINGS))
  File.open(SETTINGS, 'w') { |file| file << initializer }
end

def initializer
  <<~SETTINGS
    # frozen_string_literal: true
    require 'lemur'

    DEFAULT_KEYS = %w[RAILS_ENV]

    Lemur.configure do |config|
      config.add_keys(DEFAULT_KEYS, true)
      # config.add_keys(STAGING_KEYS, ENV['APP_ENV'] == 'staging')
      # config.add_keys(PRODUCTION_KEYS, ENV['APP_ENV'] == 'production')
    end

    Lemur.check!
  SETTINGS
end
