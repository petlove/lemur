# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lemur::Configuration, type: :model do
  describe '#initialize' do
    subject { described_class.new }

    it { is_expected.to be_a(described_class) }
    it { is_expected.to have_attributes(key_sets: []) }
  end

  describe '#add_keys' do
    subject { instance.add_keys(keys, clause) }
    let(:instance) { described_class.new }
    let(:keys) { { keys: %w[RAILS_ENV] } }
    let(:clause) { true }

    before { subject }

    it { expect(instance.key_sets.length).to eq(1) }
    it { expect(instance.key_sets.first).to have_attributes(keys: keys, clause: clause) }
  end
end
