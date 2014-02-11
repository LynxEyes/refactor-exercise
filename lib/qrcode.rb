require 'qrcode/capacity'
require 'qrcode/encoder'

module QRCode
  class CLI
    attr_reader :dark_square, :light_square, :margin, :default_color

    def initialize(content, options = {})
      @content = content
      @margin = options.fetch(:margin, 1)
      @size = options.fetch(:size, 1)
      @dark_square = options.fetch(:dark_square, "\e[40m  ")
      @light_square = options.fetch(:light_square, "\e[107m  ")
      @default_color = options.fetch(:default_color, "\e[0m")
      @grid = options.fetch(:grid, false)
    end

    def to_s
      grid = @grid ? @grid : Encoder.new(@content).grid

      # Sets each square to light or dark
      grid = grid.map do |row|
        row.map do |square|
          square ? dark_square : light_square
        end
      end

      # Add top, bottom margin
      horizontal_margin = Array.new(margin, Array.new(grid.first.length, light_square))
      grid = add_margin(grid, horizontal_margin)

      # Add left, right margin
      vertical_margin = [light_square] * margin
      grid = grid.map do |row|
        add_margin(row, vertical_margin)
      end

      cleanup(grid)
    end

    private

    def add_margin(grid_or_row, margin)
      margin + grid_or_row + margin
    end

    def cleanup(str)
      str = str.map { |row| row.join }.join("\n")
      str + "\n" + default_color
    end
  end
end
