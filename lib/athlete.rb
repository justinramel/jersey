module Jersey
  class Athlete
    attr_accessor :period, :name, :miles, :hours, :minutes, :feet

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

    def to_s
      "#{period}\t#{name}\t#{miles}mi\t#{hours}hr#{minutes}m\t#{feet}ft"
    end

    private

    def last_monday
      DateTime.parse("Monday").strftime("%b %d, %Y")
    end

  end
end
