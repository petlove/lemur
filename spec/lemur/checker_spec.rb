# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lemur::Checker, type: :model do
  describe '.check!' do
    subject { described_class.check!(key_sets) }
    let(:key_sets) do
      [
        Lemur::KeySet.new(%w[RAILS_ENV], true),
        Lemur::KeySet.new(%w[RACK_ENV], false)
      ]
    end

    context 'without RAILS_ENV' do
      it { expect { subject }.to raise_error(Dotenv::MissingKeys) }
    end

    context 'with RAILS_ENV' do
      before { ENV['RAILS_ENV'] = 'development' }
      after { ENV['RAILS_ENV'] = nil }

      it { expect { subject }.not_to raise_error }
    end
  end
end
