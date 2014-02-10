require 'spec_helper'
require 'qrcode'

describe QRCode::CLI do
  let(:dark) { "\e[40m" }
  let(:light) { "\e[107m" }
  let(:default) { "\e[0m" }
  let(:newline) { "\n" }

  let(:qr_code) { QRCode::CLI.new('http://goodguide.com', options) }

  describe 'bin/qrcode' do
    it 'executable outputs correct qr code' do
      qr_code_file = File.read('fixtures/goodguide_com.qrcode')

      expect(
        `bin/qrcode http://goodguide.com`
      ).to eq(qr_code_file)
    end
  end

  describe 'default square' do
    let(:options) { { } }

    it 'prints a dark square' do
      expect(qr_code.dark_square).to eq(dark + '  ')
    end

    it 'prints a light square' do
      expect(qr_code.light_square).to eq(light + '  ')
    end
  end

  describe 'square injected with different symbol' do
    let(:options) { { light_square: '  ', dark_square: '[]' } }

    it 'prints a dark square' do
      expect(qr_code.dark_square).to eq('[]')
    end

    it 'prints a light square' do
      expect(qr_code.light_square).to eq('  ')
    end
  end

  describe '#determine_size' do
    let(:options) { { error_correction: :l } }

    it 'pics the smallest size possible size low error level' do
      expect(qr_code.determine_size).to eq(2)
    end

    context 'with high error_correction' do
      let(:options) { { error_correction: :h } }

      it 'picks a higher size' do
        expect(qr_code.determine_size).to eq(3)
      end
    end
  end

  describe '#convert_to_ascii' do
    let(:options) do
      { light_square: '[]', dark_square: '  ', default_color: '' }
    end

    let(:qr_values) do
      [
        [ true,  false, true,  false, true  ],
        [ false, false, false, false, true  ],
        [ true,  true,  false, true,  false ],
        [ false, false, true,  false, true  ],
        [ true,  false, false, true,  false ],
      ]
    end

    it 'converts an array of bolean values to light and dark squares' do
      ascii =  "[][][][][][][]\n"
      ascii += "[]  []  []  []\n"
      ascii += "[][][][][]  []\n"
      ascii += "[]    []  [][]\n"
      ascii += "[][][]  []  []\n"
      ascii += "[]  [][]  [][]\n"
      ascii += "[][][][][][][]\n"
      puts ascii

      expect(qr_code.convert_to_ascii(qr_values)).to eq(ascii)
    end

    context 'with larger margin' do
      let(:options) do
        {
          light_square: '[]',
          dark_square: '  ',
          default_color: '',
          margin: 2
        }
      end

      it 'creates a larger margin' do
        ascii =  "[][][][][][][][][]\n"
        ascii += "[][][][][][][][][]\n"
        ascii += "[][]  []  []  [][]\n"
        ascii += "[][][][][][]  [][]\n"
        ascii += "[][]    []  [][][]\n"
        ascii += "[][][][]  []  [][]\n"
        ascii += "[][]  [][]  [][][]\n"
        ascii += "[][][][][][][][][]\n"
        ascii += "[][][][][][][][][]\n"
        puts ascii

        expect(qr_code.convert_to_ascii(qr_values)).to eq(ascii)
      end
    end
  end
end


