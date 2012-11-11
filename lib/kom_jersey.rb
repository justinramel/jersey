require './lib/winner'

module Jersey
  class KoMJersey

    attr_accessor :riders, :period

    def initialize(riders)
      @riders = riders.sort_by!(&:feet).reverse
      @period = riders.first.period
    end

    def names
        riders.map(&:name)
    end

    def feet
        riders.map(&:feet)
    end

    def winner_by
      return '' if riders.count < 2

      Winner.new(riders[0], riders[1], 'feet').to_s
    end

  end
end
