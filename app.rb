require 'sinatra'
require './lib/strava_gateway'

get '/' do
  redirect '/race?rider[]=1108047&rider[]=1193339&rider[]=605007'
end

get '/race' do
  @riders = riders_from_params
  @period = @riders.first.period
  @height = @riders.size * 100

  @riders_miles, @miles = riders_miles(@riders)
  @riders_feet,  @feet  = riders_feet(@riders)

  erb :home
end

def riders_from_params
  riders = []
  rider_ids = params[:rider]
  rider_ids = [1108047, 1193339, 605007] if !rider_ids

  rider_ids.each do |rider_id|
    riders << Jersey::StravaGateway.get_athlete(rider_id)
  end
  riders
end

def riders_miles(riders)
  riders_miles = ""
  miles        = ""
  riders.sort { |x, y| x.miles.to_i <=> y.miles.to_i }.reverse.each do |rider|
    riders_miles = riders_miles + "'#{rider.name}',"
    miles        = miles + "#{rider.miles},"
  end
  [riders_miles, miles]
end

def riders_feet(riders)
  riders_feet = ""
  feet        = ""

  @riders.sort { |x, y| x.feet <=> y.feet }.reverse.each do |rider|
    riders_feet = riders_feet + "'#{rider.name}',"
    feet        = feet + "#{rider.feet},"
  end

  [riders_feet, feet]
end
