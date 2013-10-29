require 'sinatra/base'

require 'json/ext'
require 'mongo'
require 'httparty'

require 'omniauth'
require 'omniauth-google-oauth2'

require_relative 'routes/init'
require_relative 'helpers/init'
require_relative 'models/init'

class Application < Sinatra::Base

  configure do
    set :app_file, __FILE__

    CONFIG = YAML.load(File.open('config/config.yml'))

    conn = MongoClient.new("localhost", 27017)
    set :mongo_connection, conn
    set :mongo_db, conn.db('NotifyMe')

    use Rack::Session::Cookie, :secret => CONFIG['RACK_COOKIE_SECRET']

    use OmniAuth::Builder do
      provider :google_oauth2, CONFIG['GOOGLE_KEY'], CONFIG['GOOGLE_SECRET'],
               {
                     :name => "google",
                     :scope => "userinfo.email,userinfo.profile",
               }
    end
    # This is used to redirect to failure even in dev mode
    OmniAuth.config.on_failure = Proc.new { |env|
      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
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