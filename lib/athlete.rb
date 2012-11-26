require 'chronic'

module Jersey
  class Athlete

    attr_accessor :id, :period, :name, :miles, :hours, :minutes, :feet

    def initialize(data)
      @id      = data[:id]
      @period  = data[:period]
      @name    = data[:name]
      @miles   = data[:miles].to_f
      @hours   = data[:hours]
      @minutes = data[:minutes]
      @feet    = data[:feet].to_f
      validate!
    end

    def to_s
      "#{id}\t#{period}\t#{name}\t#{miles}mi\t#{hours}hr#{minutes}m\t#{feet}ft"
    end

    private

    def validate!
      period_start = period.split(/ - /)[0]
      if (period_start != last_monday)
        self.miles   = 0
        self.hours   = 0
        self.minutes = 0
        self.feet    = 0
      end
      self
    end

    def last_monday
      today = Chronic.parse('today')
      if today.monday?
        today.strftime("%b %d, %Y")
      else
        Chronic.parse('last monday').strftime("%b %d, %Y")
      end
    end

  end
end
