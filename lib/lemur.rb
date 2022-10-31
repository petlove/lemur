# frozen_string_literal: true

require 'lemur/version'
require 'lemur/missing_keys'
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
      return if skip_check?

      Lemur::Checker.check!(configuration.key_sets)
    end

    def clear!
      @configuration = nil
    end

    def configuration
      @configuration ||= Configuration.new
    end

    private

    def skip_check?
      @skip_check ||= ENV.fetch('LEMUR_SKIP_CHECK', false)
    end
  end
end
