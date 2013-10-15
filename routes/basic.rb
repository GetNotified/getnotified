class Application < Sinatra::Base

  get '/' do
    haml :index
  end

end