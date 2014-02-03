require "rqrcode"
require "qrcode/version"

# http://en.wikipedia.org/wiki/QR_Code
#
# QR Code Terminology
#
# Module:
#   Square dots in contasting color making up a grid
#
# Version:
#   The size of the grid in modules. Version can be 1 through 40.
#   Version 1 = 21x21 modules, version 2 = 25x25... version 40 = 177x177.
#
# Level:
#   The error correcting level.
#   L = Low (7%)
#   M = Medium (15%)
#   Q = Quartile (25%)
#   H = High (30%)
#

module QRCode
  class CLI
    def initialize(content, options = {})
      @content = content
      @dark = options[:dark]
      @light = options[:light]
      @level = options[:level]
      @version = options[:version]
    end

    def dark_module
      (@dark || "\e[40m") + '  '
    end

    def light_module
      (@light || "\e[107m") + '  '
    end

    def default_color
      "\e[0m"
    end

    def level
      @level || :l
    end

    def version
      @version || 1
    end

    def to_s
      size = version
      begin
        qr_code = RQRCode::QRCode.new(@content, size: size, level: level)
      rescue RQRCode::QRCodeRunTimeError => e
        # If the requested size is not big enough to encode content
        # try one size bigger.
        size += 1
        raise e if size > 40
        retry
      end
      convert_to_ascii(qr_code.modules)
    end

    def convert_to_ascii(grid)
      string = ''
      grid.each_with_index do |row, index|
        # Add the top quite zone
        if index == 0
          2.times do
            (row.length + 4).times do
              string += light_module
            end
            string += "\n"
          end
        end

        # Add quite zone to the left of this row
        string += (light_module + light_module)

        # Add the QR Modules
        row.each do |mod|
          if mod == true
            string += dark_module
          else
            string += light_module
          end
        end

        # Add quite zone to the right of this row
        string += (light_module + light_module)
        string += "\n"

        # Add the bottom quite zone
        if index == grid.length - 1
          2.times do
            (row.length + 4).times do
              string += light_module
            end
            string += "\n"
          end
        end
      end
      string.chomp + default_color
    end
  end
end
