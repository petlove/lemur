# frozen_string_literal: true

module Lemur
  class Configuration
    attr_accessor :key_sets

    def initialize
      @key_sets = []
    end

    def add_keys(keys, clause)
      @key_sets << Lemur::KeySet.new(keys, clause)
    end
  end
end
