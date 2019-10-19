# frozen_string_literal: true

RSpec.describe Lemur, type: :module do
  it { expect(described_class::VERSION).not_to be_nil }

  describe '.configure' do
    subject do
      described_class.configure do |config|
        config.add_keys(keys, clause)
      end
    end

    let(:keys) { { keys: %w[RAILS_ENV] } }
    let(:clause) { true }

    before do
      described_class.clear!
      subject
    end

    it { expect(described_class.configuration).to be_a(Lemur::Configuration) }
    it { expect(described_class.configuration.key_sets.length).to eq(1) }
    it { expect(described_class.configuration.key_sets.first).to have_attributes(keys: keys, clause: clause) }
  end

  describe '.check!' do
    subject { described_class.check! }
    let!(:configuration) do
      described_class.clear!
      described_class.configure do |config|
        config.add_keys(keys, clause)
      end
    end
    let(:key_sets) { [Lemur::KeySet.new(keys, clause)] }
    let(:keys) { { keys: %w[RAILS_ENV] } }
    let(:clause) { true }

    after { subject }

    it { expect(Lemur::Checker).to receive(:check!).once }
  end
end
