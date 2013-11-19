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
    @user = find_user_by_uid session[:uid]
    haml :dashboard
  end
end