class Application < Sinatra::Base
  register Sinatra::ConfigFile

  config_file 'config/config.yml'

  get '/' do
    haml :index
  end

  get '/services/:service' do |serv|
    haml :reddit
  end
end