require 'spec_helper'
require 'qrcode/hash_refinements'

module TestModule
  using QRCode::HashRefinements

  def self.slice(hash, *keys)
    hash.slice(*keys)
  end
end

describe QRCode::HashRefinements do
  subject { TestModule }

  describe '.slice' do
    let(:test_hash) do
      {
        one:   1,
        two:   2,
        three: 3,
        four:  4
      }
    end

    it 'returns the sub-hash that contains the given keys' do
      expect(
        TestModule.slice(test_hash, :one, :two)
      ).to eq(one: 1, two: 2)
    end

    it 'when a given key does not exist, the result also does not have it' do
      expect(
        TestModule.slice(test_hash, :one, :five)
      ).to eq(one: 1)
    end
  end
end
