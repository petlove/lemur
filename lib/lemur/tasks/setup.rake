# frozen_string_literal: true

require 'fileutils'

SETTINGS = 'config/initializers/lemur.rb'

namespace :lemur do
  desc 'Install the initializer to the gem Lemur works'
  task :install do
    create_initializer
  end
end

def create_initializer
  FileUtils.mkdir_p(File.dirname(SETTINGS))
  File.open(SETTINGS, 'w') { |file| file << settings }
end

def settings
  <<~SETTINGS
    # frozen_string_literal: true

    Lemur.configure do |config|
      config.static.header = Lemur.static.default_header('MyAppName')
      config.static.token = 'my static token value'
    end
  SETTINGS
end
