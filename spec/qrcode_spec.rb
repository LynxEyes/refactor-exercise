require 'minitest/autorun'
require 'minitest/pride'
require 'qrcode'

describe QRCode::CLI do
  let(:dark) { "\e[40m" }
  let(:light) { "\e[107m" }
  let(:default) { "\e[0m" }
  let(:newline) { "\n" }

  let(:options) { { light: light, dark: dark } }
  let(:qr_code) { QRCode::CLI.new('http://goodguide.com', options) }

  it 'prints a dark square' do
    qr_code.dark_module.must_equal(dark + '  ')
  end

  it 'prints a light square' do
    qr_code.light_module.must_equal(light + '  ')
  end

  describe '#convert_to_ascii' do
    it 'converts an array of modules to ansi escaped text' do
      qr_modules = [[ true,  false, true,  false, true  ]]
      qr_modules << [ false, false, false, false, true  ]
      qr_modules << [ true,  true,  false, true,  false ]
      qr_modules << [ false, false, true,  false, true  ]
      qr_modules << [ true,  false, false, true,  false ]

      x = dark  + '  '
      o = light + '  '

      # The outputed QR Code should be surrounded by
      # a two module "quiet zone"
      ascii =  o + o + o + o + o + o + o + o + o + newline
      ascii += o + o + o + o + o + o + o + o + o + newline
      ascii += o + o + x + o + x + o + x + o + o + newline
      ascii += o + o + o + o + o + o + x + o + o + newline
      ascii += o + o + x + x + o + x + o + o + o + newline
      ascii += o + o + o + o + x + o + x + o + o + newline
      ascii += o + o + x + o + o + x + o + o + o + newline
      ascii += o + o + o + o + o + o + o + o + o + newline
      ascii += o + o + o + o + o + o + o + o + o + default

      qr_code.convert_to_ascii(qr_modules).must_equal ascii
    end
  end

  describe '#to_s' do
    it 'outputs correct ascii string' do
      qr_code_file = File.read('fixtures/goodguide_com.qrcode').chomp

      qr_code.to_s.must_equal qr_code_file
    end
  end

  describe 'bin/qrcode' do
    it 'executable outputs correct qr code' do
      qr_code_file = File.read('fixtures/goodguide_com.qrcode')

      proc { print `bin/qrcode http://goodguide.com` }.must_output qr_code_file
    end
  end
end


