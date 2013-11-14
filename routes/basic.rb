class Application < Sinatra::Base

  get '/' do
    haml :index
  end

  get '/services/reddit/?' do
    haml :reddit
  end

  get '/services/weather/?' do
    haml :weather
  end

  get '/dashboard/?' do
    authenticate
    haml :dashboard
  end
end