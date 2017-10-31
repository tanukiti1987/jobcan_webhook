require 'sinatra/activerecord'
require 'sinatra/reloader'

require_relative 'models/init'

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  helpers do
  end

  get '/robot.txt' do
    erb :"robot.txt"
  end

  get '/' do
    haml :index
  end
end
