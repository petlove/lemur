# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lemur::MissingKeys, type: :model do
  describe '#raise' do
    subject { raise described_class, message }
    let(:message) { 'Missing required configuration key: ["RAILS_ENV"]' }

    it { expect { subject }.to raise_error(described_class, message) }
  end
end
