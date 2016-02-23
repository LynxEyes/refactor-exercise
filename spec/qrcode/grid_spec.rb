require 'spec_helper'
require 'qrcode/grid'

describe QRCode::Grid do
  subject { described_class.new(options) }
  let(:options) do
    {
      margin: 1,
      light_square: '[]',
      dark_square: '  ',
      default_color: ''
    }
  end

  describe '#new' do
    subject { described_class.new }

    shared_examples 'defaults to' do |property, value|
      property_default = "QRCode::Grid::Defaults::#{property.to_s.upcase}"
      it "#{property_default} when not given #{property}" do
        expect(subject.send(property)).to eq(value)
      end
    end

    it_behaves_like 'defaults to', :margin, QRCode::Grid::Defaults::MARGIN
    it_behaves_like 'defaults to', :light_square, QRCode::Grid::Defaults::LIGHT_SQUARE
    it_behaves_like 'defaults to', :dark_square, QRCode::Grid::Defaults::DARK_SQUARE
    it_behaves_like 'defaults to', :default_color, QRCode::Grid::Defaults::DEFAULT_COLOR
  end

  describe '.to_s' do
    let(:qr_code) do
      "[][][][][][][]\n" +
      "[]  []  []  []\n" +
      "[][][][][]  []\n" +
      "[]    []  [][]\n" +
      "[][][]  []  []\n" +
      "[]  [][]  [][]\n" +
      "[][][][][][][]\n"
    end

    let(:data) do
      [
        [true,  false, true,  false, true ],
        [false, false, false, false, true ],
        [true,  true,  false, true,  false],
        [false, false, true,  false, true ],
        [true,  false, false, true,  false],
      ]
    end

    it 'converts an array of boolean values to light and dark squares' do
      subject.data = data
      expect(subject.to_s).to eq(qr_code)
    end
  end
end
