module QRCode
  class Grid
    module Defaults
      MARGIN = 1
      DARK_SQUARE = "\e[40m  ".freeze
      LIGHT_SQUARE = "\e[107m  ".freeze
      DEFAULT_COLOR = "\e[0m".freeze
    end

    attr_reader :margin, :dark_square, :light_square, :default_color
    attr_accessor :data

    def initialize(margin: Defaults::MARGIN,
                   dark_square: Defaults::DARK_SQUARE,
                   light_square: Defaults::LIGHT_SQUARE,
                   default_color: Defaults::DEFAULT_COLOR)
      @margin = margin
      @dark_square = dark_square
      @light_square = light_square
      @default_color = default_color
    end

    def to_s
      %i(
        add_top_bottom_margins
        add_left_right_margins
        print_grid
        format_grid
      ).reduce(data) do |input, function|
        send(function, input)
      end
    end

    private

    def add_top_bottom_margins(grid)
      top_bottom_margin = Array.new(margin, Array.new(grid.first.length, false))
      top_bottom_margin + grid + top_bottom_margin
    end

    def add_left_right_margins(grid)
      grid.map do |row|
        [false] * margin +
        row +
        [false] * margin
      end
    end

    def print_grid(grid)
      grid.map do |row|
        row.map do |square|
          square ? dark_square : light_square
        end
      end
    end

    def format_grid(grid)
      grid = grid.map { |row| row.join }.join("\n")
      grid + "\n" + default_color
    end
  end
end
