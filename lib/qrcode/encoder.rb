require 'rqrcode'
require 'qrcode/version'

module QRCode
  class Encoder
    def initialize(content)
      @content = content
    end

    def grid
      RQRCode::QRCode.new(
        @content,
        size: size,
        level: :l
      ).modules
    end

    def size
      character_count_list.find_index(
        smallest_character_count
      ) + 1
    end

    def smallest_character_count
      character_count_list.find do |character_count|
        @content.size < character_count
      end
    end

    def character_count_list
      CAPACITY[:l][:byte]
    end
  end
end
