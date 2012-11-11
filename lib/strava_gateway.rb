require 'faraday'

require './lib/athlete'

module Jersey
  class StravaGateway

    def self.get_athlete(id)
      response = Faraday.get("http://www.strava.com/athletes/#{id}")
      data     = parse(response.body)

      athlete = Athlete.new
      athlete.period  = data[:period]
      athlete.name    = data[:name]
      athlete.miles   = data[:miles]
      athlete.hours   = data[:hours]
      athlete.minutes = data[:minutes]
      athlete.feet    = data[:feet]
      athlete.validate!
    end

    def self.parse(body)
      h = {}
      h[:period]  = body.slice(/>Activities for (.+?)\n/, 1)
      h[:name]    = body.slice(/id='athlete-name'>(.+?)</,   1)
      h[:miles]   = body.slice(/>(.+?)<abbr class='unit' title='miles'>/, 1)
      h[:hours]   = body.slice(/>(.+?)<abbr class='unit' title='hours'>/, 1)
      h[:minutes] = body.slice(/>(.+?)<abbr class='unit' title='minutes'>/,  1)
      h[:feet]    = body.slice(/>(.+?)<abbr class='unit' title='feet'>/,  1)
      h[:feet ]   = h[:feet].sub(',', '').to_i
      h
    end
  end
end
