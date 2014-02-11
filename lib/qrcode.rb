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
      if @grid
        grid = @grid
      else
        grid = Encoder.new(@content).grid
      end

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
  end
end
