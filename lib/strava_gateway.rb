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
          athletes << create_athlete(response.body)
        end

        hydra.queue(request)
      end

      hydra.run
      athletes
    end

    def self.create_athlete(body)
      data = parse(body)
      Athlete.new(data)
    end

    def self.parse(body)
      h = {}
      h[:id]      = body.slice(/<link href='http:\/\/www.strava.com\/athletes\/(.+?)' rel='canonical'>/, 1)
      h[:period]  = body.slice(/>Activities for (.+?)\n/,  1)
      h[:name]    = body.slice(/id='athlete-name'>(.+?)</, 1)
      h[:miles]   = body.slice(/>(.+?)<abbr class='unit' title='miles'>/, 1)
      h[:hours]   = body.slice(/>(.+?)<abbr class='unit' title='hours'>/, 1)
      h[:minutes] = body.slice(/>(.+?)<abbr class='unit' title='minutes'>/, 1)
      h[:feet]    = body.slice(/>(.+?)<abbr class='unit' title='feet'>/, 1)
      h[:feet ]   = h[:feet].sub(',', '') if h[:feet]
      h
    end

  end
end
