# frozen_string_literal: true

require 'dotenv'

module Lemur
  class KeySet
    attr_accessor :keys, :clause

    def initialize(keys, clause)
      @keys = keys
      @clause = clause
    end
  end
end
