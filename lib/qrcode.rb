require 'rqrcode'
require 'qrcode/version'
require 'qrcode/capacity'

module QRCode
  class CLI
    attr_reader :dark_square, :light_square, :margin,
      :size, :error_correction, :default_color

    def initialize(content, options = {})
      @content = content
      @margin = options.fetch(:margin, 1)
      @size = options.fetch(:size, 1)
      @dark_square = options.fetch(:dark_square, "\e[40m  ")
      @light_square = options.fetch(:light_square, "\e[107m  ")
      @default_color = options.fetch(:default_color, "\e[0m")
      @error_correction = options.fetch(:error_correction, :l)
    end

    def to_s
      convert_to_ascii(get_grid)
    end

    def determine_size
      character_count_list.find_index(
        smallest_character_count
      ) + 1
    end

    def convert_to_ascii(grid)
      grid = add_margins(grid)
      grid = map_squares(grid)
      grid = grid.map { |row| row.join }.join("\n")
      grid + "\n" + default_color
    end

    private

    def add_margins(grid)
      grid = x_margin(grid) + grid + x_margin(grid)
      grid.map do |row|
        y_margin + row + y_margin
      end
    end

    def map_squares(grid)
      grid.map do |row|
        row.map { |square| square ? dark_square : light_square }
      end
    end

    def x_margin(grid)
      Array.new(margin, Array.new(grid.first.length, false))
    end

    def y_margin
      [false] * margin
    end

    def smallest_character_count
      character_count_list.find do |character_count|
        @content.size < character_count
      end
    end

    def character_count_list
      CAPACITY[error_correction][:byte]
    end

    def get_grid
      RQRCode::QRCode.new(
        @content,
        size: determine_size,
        level: error_correction
      ).modules
    end
  end
end
