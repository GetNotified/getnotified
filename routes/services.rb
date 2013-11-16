class Application < Sinatra::Base
  include Mongo

  post '/services/reddit/submit/?' do
    content_type :json
    score = params[:score]

    unless score
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    uid = session[:uid]
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

  post '/services/weather/submit/?' do
    content_type :json
    type = params[:type]
    temperature = params[:temperature]
    city = params[:city]

    if type.empty? or city.empty? or temperature.empty?
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    uid = session[:uid]
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

end