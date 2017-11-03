require 'sinatra/activerecord'
require 'sinatra/reloader'

require_relative 'models/init'

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  helpers do
    def set_authentication
      request.body.rewind
      data = JSON.parse(request.body.read, symbolize_names: true)
      @authentication = Authentication.find_by(access_key: data[:access_key], secret_key: data[:secret_key])

      halt 403, "Can't Authenticate" if @authentication.nil?
    end
  end

  get '/robot.txt' do
    erb :"robot.txt"
  end

  get '/' do
    haml :index
  end

  post '/create' do
    @authentication =
      Authentication.create(
        client_name: params['client_name'],
        user_name: params['user_name'],
        password: params['password'])

    if @authentication
      haml :create
    else
      # TODO: add flash message
      redirect to('/')
    end
  end

  post '/clock_in' do
    set_authentication
  end

  post '/clock_out' do
    set_authentication
  end
end
