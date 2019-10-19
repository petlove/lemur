# frozen_string_literal: true

require 'lemur/version'
require 'lemur/key_set'
require 'lemur/checker'
require 'lemur/configuration'

module Lemur
  require 'lemur/railtie' if defined?(Rails)

  class << self
    def configure
      yield(configuration)
    end

    def check!
      Lemur::Checker.check!(configuration.key_sets)
    end

    def clear!
      @configuration = nil
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
