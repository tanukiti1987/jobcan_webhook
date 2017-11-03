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

  post '/create' do
    authentication =
      Authentication.create(
        client_name: params['client_name'],
        user_name: params['user_name'],
        password: params['password'])

    if authentication
      # TODO: implement later
      haml :create
    else
      # TODO: add flash message
      redirect to('/')
    end
  end
end
