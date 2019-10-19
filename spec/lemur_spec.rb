# frozen_string_literal: true

RSpec.describe Lemur, type: :module do
  it { expect(described_class::VERSION).not_to be_nil }
end
