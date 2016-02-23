require 'qrcode/capacity'
require 'qrcode/encoder'
require 'qrcode/grid'
require 'qrcode/hash_refinements'

module QRCode
  class CLI
    using HashRefinements
    attr_reader :dark_square, :light_square, :margin, :default_color,
                :grid, :encoder

    def initialize(content, options = {})
      @content = content
      @grid = Grid.new(options.slice(:margin,
                                     :dark_square,
                                     :light_square,
                                     :default_color))
      @encoder = Encoder
    end

    def to_s
      @grid.data = @encoder.new(@content).data
      @grid.to_s
    end
  end
end
