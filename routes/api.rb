class Application < Sinatra::Base

  get '/api/?' do
    "NotifyMe API v1"
  end

  post '/api/test/notification' do
    content_type :json

    regId = params[:regId]
    unless regId
      return {success: 'false',
        error: 'Missing parameters'}.to_json
    end

    body = {
        message: "Test notification from your dashboard",
        service: "NotifyMe"
    }
    send_android_push(regId, body)

    # Executed successfully
    {success: 'true'}.to_json
  end

  post '/api/device/register/?' do
    content_type :json

    regId = params[:regId]
    uid  = params[:uid]
    device_type = params[:device_type]
    device_name = params[:device_name]
    users_coll = settings.mongo_db.collection("users")
    user = users_coll.find_one({:uid => uid})

    unless regId and uid and device_type
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    unless user
      return {success: 'false',
              error: 'User not found'}.to_json
    end

    unless user['devices'].nil?
      unless user['devices'].select { |device| device['regId'] == regId }.empty?
        return {success: 'false',
                error:   'Device already registered'}.to_json
      end
    end

    users_coll.update( {uid: uid},
       {
           "$addToSet" => { :devices => { :regId => regId, :type => device_type, :name => device_name } }
       },
       {upsert: true})

    body = {
        message: "You have successfully registered your device with NotifyMe!",
        service: "NotifyMe"
    }
    send_android_push(regId, body)

    # Executed successfully
    {success: 'true'}.to_json
  end

  post '/api/device/delete/?' do
    content_type :json

    regId = params[:regId]
    uid  = params[:uid]

    unless regId and uid
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    users_coll = settings.mongo_db.collection("users")
    user = users_coll.find_one({:uid => uid})

    unless user
      return {success: 'false',
              error: 'User not found'}.to_json
    end

    if user['devices'].nil? or user['devices'].select { |device| device['regId'] == regId }.empty?
      puts "Device not found"
      return {success: 'false',
              error:   'Device not found'}.to_json
    end

    users_coll.update( {uid: uid},
                       {
                           "$pull" => { :devices => { :regId => regId } }
                       },
                       {upsert: true})

    # Executed successfully
    {success: 'true'}.to_json
  end

  post '/api/notification/delete/?' do
    content_type :json

    id = params[:id]
    unless id
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    notifications_coll = settings.mongo_db.collection("notifications")
    notifications_coll.remove(:_id => BSON::ObjectId(id))

    # Executed successfully
    {success: 'true'}.to_json
  end

  post '/api/notification/list/?' do
    content_type :json

    uid = params[:uid]
    unless uid
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    notifications_coll = settings.mongo_db.collection("notifications")
    notifications = notifications_coll.find(:uid => uid).to_a

    # Executed successfully
    {success: 'true',
     notifications: notifications}.to_json
  end

  post '/api/account/delete/?' do
    content_type :json

    email = params[:email]
    uid  = params[:uid]

    unless email and uid
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    users_coll = settings.mongo_db.collection("users")
    users_coll.remove({:uid => uid, :email => email})

    notifications_coll = settings.mongo_db.collection("notifications")
    notifications_coll.remove(:uid => uid)

    session[:uid] = nil
    session[:fullname] = nil

    # Executed successfully
    {success: 'true'}.to_json
  end

  post '/api/weather/search/city?' do
    content_type :json

    city = params[:city]
    unless city
      return {success: 'false',
              error: 'Missing argument'}.to_json
    end
    get("http://api.openweathermap.org/data/2.5/find",
        query: {q: city, units: "metric", mode: "json"}).to_json
  end
end