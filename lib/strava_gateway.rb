require 'faraday'

require './lib/athlete'

module Jersey
  class StravaGateway

    def self.get_athlete(id)
      response = Faraday.get("http://www.strava.com/athletes/#{id}")
      body     = response.body
      period   = body.slice(/<h2 id='interval-value'>Activities for (.+?)\n/, 1)
      name     = body.slice(/<h1 class='topless' id='athlete-name'>(.+?)</,   1)
      miles    = body.slice(/<strong>(.+?)<abbr class='unit' title='miles'>/, 1)
      hours    = body.slice(/<strong>(.+?)<abbr class='unit' title='hours'>/, 1)
      minutes  = body.slice(/abbr>(.+?)<abbr class='unit' title='minutes'>/,  1)
      feet     = body.slice(/<strong>(.+?)<abbr class='unit' title='feet'>/,  1)
      feet     = feet.sub(',', '').to_i

      period_start = period.split(/ - /)[0]
      if (period_start != self.last_monday)
        miles   = 0
        hours   = 0
        minutes = 0
        feet    = 0
      end

      Athlete.new.tap do |a|
        a.period  = period
        a.name    = name
        a.miles   = miles
        a.hours   = hours
        a.minutes = minutes
        a.feet    = feet
      end
    end

    def self.last_monday
      DateTime.parse("Monday").strftime("%b %d, %Y")
    end

  end
end
