require 'typhoeus'

require './lib/athlete'

module Jersey
  class StravaGateway

    def self.get_athletes(ids)
      athletes = []
      hydra = Typhoeus::Hydra.new(:max_concurrency => 5)

      ids.each do |id|
        request = Typhoeus::Request.new("http://www.strava.com/athletes/#{id}")

        request.on_complete do |response|
          data     = parse(response.body)
          athletes << create_athlete(id, data)
        end
        hydra.queue(request)
      end

      hydra.run
      athletes
    end

    def self.parse(body)
      h = {}
      h[:period]  = body.slice(/>Activities for (.+?)\n/,  1)
      h[:name]    = body.slice(/id='athlete-name'>(.+?)</, 1)
      h[:miles]   = body.slice(/>(.+?)<abbr class='unit' title='miles'>/, 1)
      h[:hours]   = body.slice(/>(.+?)<abbr class='unit' title='hours'>/, 1)
      h[:minutes] = body.slice(/>(.+?)<abbr class='unit' title='minutes'>/, 1)
      h[:feet]    = body.slice(/>(.+?)<abbr class='unit' title='feet'>/, 1)
      h[:feet ]   = h[:feet].sub(',', '') if h[:feet]
      h
    end

    def self.create_athlete(id, data)
      athlete = Athlete.new
      athlete.id      = id
      athlete.period  = data[:period]
      athlete.name    = data[:name]
      athlete.miles   = data[:miles].to_f
      athlete.hours   = data[:hours]
      athlete.minutes = data[:minutes]
      athlete.feet    = data[:feet].to_f
      athlete.validate!
    end
  end
end
