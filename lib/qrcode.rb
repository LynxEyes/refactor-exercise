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
      character_count_list(:byte).find_index(
        smallest_character_count
      ) + 1
    end

    def convert_to_ascii(grid)
      tmp_grid = Array.new(margin, Array.new(grid.first.length, false))
      tmp_grid += grid
      tmp_grid += Array.new(margin, Array.new(grid.first.length, false))

      tmp_grid = tmp_grid.map do |row|
        [false] * margin +
        row +
        [false] * margin
      end

      tmp_grid = tmp_grid.map do |row|
        row.map do |square|
          if square == true
            dark_square
          elsif square == false
            light_square
          end
        end
      end

      tmp_grid = tmp_grid.map { |row| row.join }.join("\n")
      tmp_grid += "\n" + default_color

      tmp_grid
    end

    def smallest_character_count
      character_count_list(:byte).find do |character_count|
        @content.size < character_count
      end
    end

    def character_count_list(type)
      case type
      when :byte
        CAPACITY[error_correction][:byte]
      when :alphanumeric
        CAPACITY[error_correction][:alphanumeric]
      when :numeric
        CAPACITY[error_correction][:numeric]
      end
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
