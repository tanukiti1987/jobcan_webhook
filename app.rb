require 'sinatra/reloader'
require 'redis'
require 'redis-namespace'
require 'sidekiq'

require_relative 'lib/init'
require_relative 'models/init'
require_relative 'workers/init'

Sidekiq.configure_server do |config|
    config.redis = { url:  ENV["REDIS_URL"] || 'redis://localhost:6379', namespace: 'sidekiq' }
end

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

  post '/slack_notification/create' do
    @authentication = Authentication.find_by(id: params['authentication_id'])
    halt 400, "Bad request" if @authentication.nil?

    @slack_notification =
      SlackNotification.create(
        authentication: @authentication,
        webhook_url: params["webhook_url"],
        channel: params["channel"]
      )

    haml :create
  end

  post '/clock_in' do
    set_authentication
    ClockInWorker.perform_async @authentication.id
  end

  post '/clock_out' do
    set_authentication
    ClockOutWorker.perform_async @authentication.id
  end
end
