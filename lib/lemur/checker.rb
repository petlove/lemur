# frozen_string_literal: true

require 'dotenv'

module Lemur
  module Checker
    module_function

    def check!(key_sets)
      Dotenv&.require_keys(key_sets&.each_with_object([]) { |key_set, obj| obj << key_set.keys if key_set.clause }
                                   &.flatten)
    end
  end
end
