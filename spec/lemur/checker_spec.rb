# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lemur::Checker, type: :model do
  describe '.check!' do
    subject { described_class.check!(key_sets) }
    let(:key_sets) do
      [
        Lemur::KeySet.new(%w[UNKNOWN_ENV], true),
        Lemur::KeySet.new(%w[RACK_ENV], false)
      ]
    end

    context 'without UNKNOWN_ENV' do
      it { expect { subject }.to raise_error(Lemur::MissingKeys) }
    end

    context 'with UNKNOWN_ENV' do
      before { ENV['UNKNOWN_ENV'] = 'development' }
      after { ENV['UNKNOWN_ENV'] = nil }

      it { expect { subject }.not_to raise_error }
    end
  end
end
