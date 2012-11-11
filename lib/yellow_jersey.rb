require './lib/winner'

module Jersey
  class YellowJersey

    attr_accessor :riders, :period

    def initialize(riders)
      @riders = riders.sort_by!(&:miles).reverse
      @period = riders.first.period
    end

    def names
        riders.map(&:name)
    end

    def miles
      url = 'http://app.strava.com/athletes/'
      riders.map { |r| "{y: #{r.miles}, url: '#{url}#{r.id}'}" }.to_s.gsub('"', '')
    end

    def winner_by
      return '' if riders.count < 2

      Winner.new(riders[0], riders[1], 'miles').to_s
    end

  end
end
