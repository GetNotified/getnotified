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

  get '/services/poly/?' do
    haml :poly
  end

  get '/dashboard/?' do
    authenticate
    @user = find_user_by_uid session[:uid]
    @notifications = find_notifications_by_uid session[:uid]
    haml :dashboard
  end

  get '/admin/?' do
    authenticate
    if is_admin? session[:uid]
      @latest_notifications = latest_notifications_sent

      @stats = {}
      @stats['sent'] = notifications_sent_count
      @stats['notif'] = notifications_count
      @stats['users'] = users_count

      haml :admin
    end
  end
end