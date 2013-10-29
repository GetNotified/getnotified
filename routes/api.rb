class Application < Sinatra::Base

  get '/api' do
    "NotifyMe API v1"
  end

  post '/api/device/register' do
    content_type :json

    regId = params[:regId]
    username  = params[:username]
    device_type = params[:device_type]
    users_coll = settings.mongo_db.collection("users")
    user = users_coll.find_one({:username => username})

    unless regId and username and device_type
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    unless user
      return {success: 'false',
              error: 'User not found'}.to_json
    end

    users_coll.update( {username: username},
       {
           "$push" => { :devices => { :regId => regId, :type => device_type } }
       },
       {upsert: true})

    send_register_confirm(regId)

    # Executed successfully
    {success: 'true'}.to_json
  end
end