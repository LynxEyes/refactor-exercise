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
    let(:grid) do
      [
        [ true,  false, true,  false, true  ],
        [ false, false, false, false, true  ],
        [ true,  true,  false, true,  false ],
        [ false, false, true,  false, true  ],
        [ true,  false, false, true,  false ],
      ]
    end

    let(:options) do
      {
        light_square: '[]',
        dark_square: '  ',
        default_color: '',
        grid: grid
      }
    end

    let(:qr_code) { QRCode::CLI.new('http://goodguide.com', options) }

    it 'converts an array of bolean values to light and dark squares' do
      ascii =  "[][][][][][][]\n"
      ascii += "[]  []  []  []\n"
      ascii += "[][][][][]  []\n"
      ascii += "[]    []  [][]\n"
      ascii += "[][][]  []  []\n"
      ascii += "[]  [][]  [][]\n"
      ascii += "[][][][][][][]\n"
      puts ascii

      expect(qr_code.to_s).to eq(ascii)
    end
  end
end


