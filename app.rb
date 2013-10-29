require 'sinatra/base'
require 'sinatra/config_file'

require 'json/ext'
require 'mongo'
require 'httparty'

require 'omniauth'
require 'omniauth-google-oauth2'

require_relative 'routes/init'
require_relative 'helpers/init'
require_relative 'models/init'

class Application < Sinatra::Base
  register Sinatra::ConfigFile

  configure do
    set :app_file, __FILE__
    conn = MongoClient.new("localhost", 27017)
    set :mongo_connection, conn
    set :mongo_db, conn.db('NotifyMe')

    config_file 'config/config.yml'

    use Rack::Session::Cookie, :secret => settings.RACK_COOKIE_SECRET

    #use OmniAuth::Builder do
    #  # For additional provider examples please look at 'omni_auth.rb'
    #  provider :google_oauth2, settings.GOOGLE_KEY, settings.GOOGLE_SECRET,
    #           {
    #               :name => "google",
    #               :scope => "userinfo.email, userinfo.profile",
    #               :prompt => "none",
    #               :image_aspect_ratio => "original",
    #               :image_size => 50
    #           }
    #end
  end

  configure :development do
    enable :logging, :dump_errors, :raise_errors
  end

  configure :qa do
    enable :logging, :dump_errors, :raise_errors
  end

  configure :production do
    set :raise_errors, false #false will show nicer error page
    set :show_exceptions, false #true will ignore raise_errors and display backtrace in browser
  end
end