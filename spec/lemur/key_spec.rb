# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lemur::KeySet, type: :model do
  describe '#initialize' do
    subject { described_class.new(keys, clause) }
    let(:keys) { { keys: %w[RAILS_ENV] } }
    let(:clause) { true }

    it { is_expected.to be_a(described_class) }
    it { is_expected.to have_attributes(keys: keys, clause: clause) }
  end
end
