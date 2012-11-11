require 'sinatra'

require './lib/strava_gateway'
require './lib/yellow_jersey'
require './lib/kom_jersey'

get '/' do
  redirect '/race?rider[]=1108047&rider[]=1193339&rider[]=605007'
end

get '/race' do
  @riders = riders_from_params
  @height = @riders.size * 100

  @yellow_jersey = Jersey::YellowJersey.new(@riders)
  @kom_jersey    = Jersey::KoMJersey.new(@riders)

  erb :home
end

def riders_from_params
  rider_ids = params[:rider]
  rider_ids = [1108047, 1193339, 605007] if !rider_ids

  rider_ids.map do |id|
    Jersey::StravaGateway.get_athlete(id)
  end
end
