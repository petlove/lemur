# frozen_string_literal: true

require 'lemur/version'

module Lemur
  require 'lemur/railtie' if defined?(Rails)
end
