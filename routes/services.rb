class Application < Sinatra::Base
  include Mongo

  # THESE SHOULD BE SHORTENED AND ACTUAL ACTION MOVED TO API

  post '/services/reddit/submit/?' do
    content_type :json
    score = params[:score]

    unless score
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    uid = session[:uid]
    unless uid
      return {success: 'false',
              error: 'You need to log in first'}.to_json
    end
    type = 'reddit-front-page'
    request = 'http://www.reddit.com/.json'

    requests_coll = settings.mongo_db.collection("requests")
    notifications_coll = settings.mongo_db.collection("notifications")

    # Will insert if doesn't already exist
    requests_coll.update({request: request},
       {
          service: 'reddit',
          type: type,
          request: request,
       },
       {upsert: true})

    notifications_coll.update({uid: uid, type: type},
      {
          uid: uid,
          service: 'reddit',
          type: type,
          score: score,
      },
      {upsert: true})
    # Executed successfully
    {success: 'true'}.to_json
  end

  post '/services/weather/temperature/submit?' do
    content_type :json

    uid = session[:uid]
    if uid.nil?
      return {success: 'false',
              error: 'You need to log in first'}.to_json
    end

    type = params[:type]
    city = params[:city]
    temperature = params[:temperature]
    if type.empty? or city.empty? or temperature.empty?
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    requests_coll = settings.mongo_db.collection("requests")
    notifications_coll = settings.mongo_db.collection("notifications")

    # Will insert if doesn't already exist
    requests_coll.update({service: 'weather', type: 'forecast'},
                         {
                             "$addToSet" => { :cities => city }
                         },
                         {upsert: true})

    notifications_coll.update({uid: uid, service: 'weather', type: type, city: city},
                          {
                              uid: uid,
                              service: 'weather',
                              type: type,
                              city: city,
                              temperature: temperature.to_f,
                          },
                          {upsert: true})
    # Executed successfully
    {success: 'true'}.to_json
  end

  post '/services/weather/forecast/submit?' do
    content_type :json

    uid = session[:uid]
    if uid.nil?
      return {success: 'false',
              error: 'You need to log in first'}.to_json
    end

    type = params[:type]
    weather = params[:weather]
    city = params[:city]
    if type.empty? or city.empty? or weather.empty?
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    requests_coll = settings.mongo_db.collection("requests")
    notifications_coll = settings.mongo_db.collection("notifications")

    # Will insert if doesn't already exist
    requests_coll.update({service: 'weather', type: 'forecast'},
                         {
                             "$addToSet" => { :cities => city }
                         },
                         {upsert: true})

    notifications_coll.update({uid: uid, service: 'weather', type: type, city: city, weather: weather},
                              {
                                  uid: uid,
                                  service: 'weather',
                                  type: type,
                                  city: city,
                                  weather: weather,
                              },
                              {upsert: true})
    # Executed successfully
    {success: 'true'}.to_json
  end

  post '/services/poly/result/submit?' do
    content_type :json

    uid = session[:uid]
    if uid.nil?
      return {success: 'false',
              error: 'You need to log in first'}.to_json
    end

    code = params[:code]
    password = params[:password]
    ddn = params[:ddn]
    if code.empty? or password.empty? or ddn.empty?
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    hash, iv = encrypt(password)

    requests_coll = settings.mongo_db.collection("requests")
    notifications_coll = settings.mongo_db.collection("notifications")

    # Will insert if doesn't already exist
    requests_coll.update({service: 'poly', type: 'result'},
                         {
                             "$addToSet" => { :credentials => {
                                 :code => code,
                                 :password => hash,
                                 :iv => iv,
                                 :ddn => ddn
                             } }
                         },
                         {upsert: true})

    notifications_coll.update({uid: uid, service: 'poly', type: 'result', code: code},
                              {
                                  uid: uid,
                                  service: 'poly',
                                  type: 'result',
                                  code: code,
                              },
                              {upsert: true})
    # Executed successfully
    {success: 'true'}.to_json
  end
end