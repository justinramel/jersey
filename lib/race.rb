module Jersey
  class Race
    attr_accessor :athletes, :period

    def initialize
      @athletes = []
      @period   = ""
    end
  end
end
