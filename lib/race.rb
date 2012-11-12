require './lib/winner'

module Jersey
  class Race
    attr_accessor :riders, :period, :unit

    def initialize(riders, unit)
      @riders = riders.sort_by! { |r| r.send(unit) }.reverse
      @period = riders.sort_by(&:period).last.period
      @unit   = unit
    end

    def names
      riders.map(&:name)
    end

    def units
      url = 'http://app.strava.com/athletes/'
      riders.map do |r|
        "{y: #{r.send(unit)}, url: '#{url}#{r.id}'}"
      end.to_s.gsub('"', '')
    end

    def winner
      return '' if riders.count < 2
      Winner.new(riders[0], riders[1], unit).to_s
    end
  end
end
