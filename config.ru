require 'sinatra'

require './app'

use Rack::Deflater
run Sinatra::Application
