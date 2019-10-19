# frozen_string_literal: true

require 'dotenv'

module Lemur
  module Checker
    module_function

    def check!(key_sets)
      return unless key_sets.any?

      Dotenv.require_keys(key_sets.each_with_object([]) { |key_set, obj| obj << key_set.keys if key_set.clause }
                                  .flatten)
    rescue Dotenv::MissingKeys => e
      raise Lemur::MissingKeys, e.message
    end
  end
end
