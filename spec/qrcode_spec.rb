require 'spec_helper'
require 'qrcode'

describe QRCode::CLI do
  describe 'bin/qrcode' do
    it 'executable outputs correct qr code' do
      qr_code_file = File.read('fixtures/goodguide_com.qrcode')

      expect(
        `bin/qrcode http://goodguide.com`
      ).to eq(qr_code_file)
    end
  end

  describe '#to_s' do
    let(:content) { 'hello world' }
    subject { described_class.new(content) }

    it 'delegates to_s to grid' do
      expect(subject.grid).to receive(:to_s)
      subject.to_s
    end
  end
end
