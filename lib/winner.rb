module Jersey
  class Winner

    attr_accessor :winner, :loser, :field

    def initialize(winner, loser, field)
      @winner = winner
      @loser  = loser
      @field  = field
    end

    def to_s
      "#{winner.name} is #{taunt} #{loser.name} by #{by} #{field}"
    end

    def taunt
      [
        'thrashing',
        'beating',
        'hammering',
        'battering',
        'caning',
        'clobbering',
        'crushing',
        'overwhelming',
        'pummeling',
        'destroying',
        'shellacking',
        'slaughtering',
        'defeating',
        'ruining',
        'annihilating',
        'trouncing',
        'demolishing',
        'soundly thrashing'
      ].sample
      'a head of'
    end

    def by
      w = winner.send(field)
      l = loser.send(field)
      "%.1f" % (w - l)
    end

  end
end
