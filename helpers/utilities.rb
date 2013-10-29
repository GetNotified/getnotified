class Application < Sinatra::Base
  include HTTParty
  helpers do
    def logged_in
      puts "Logged in?: #{!session[:uid].nil?}"
      !session[:uid].nil?
    end

    def authenticate
      # we do not want to redirect to Google when the path info starts
      # with /auth/
      pass if request.path_info =~ /^\/auth\//

      # /auth/twitter is captured by omniauth:
      # when the path info matches /auth/twitter, omniauth will redirect to twitter
      redirect to('/auth/google') unless logged_in
    end

    # HTTParty get wrapper. This serves to clean up code, as well as throw webserver errors wherever needed
    #
    def get *args, &block
      response = self.class.get *args, &block
      raise WebserverError, response.code unless response.code == 200
      response
    end

    # HTTParty POST wrapper. This serves to clean up code, as well as throw webserver errors wherever needed
    #
    def post *args, &block
      response = self.class.post *args, &block
      raise WebserverError, response.code unless response.code == 200
      response
    end
  end

  class WebserverError < StandardError
  end
end