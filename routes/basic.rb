class Application < Sinatra::Base

  get '/' do
    haml :index
  end

  get '/services/:service/?' do |serv|
    haml :reddit
  end

  get '/admin/?' do
    authenticate
    "Admin Only!"
  end
end