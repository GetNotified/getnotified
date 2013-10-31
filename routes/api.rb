class Application < Sinatra::Base

  get '/api' do
    "NotifyMe API v1"
  end

  post '/api/device/register' do
    content_type :json

    regId = params[:regId]
    uid  = params[:uid]
    device_type = params[:device_type]
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
           "$addToSet" => { :devices => { :regId => regId, :type => device_type } }
       },
       {upsert: true})

    send_register_confirm(regId)

    # Executed successfully
    {success: 'true'}.to_json
  end
end