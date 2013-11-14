class Application < Sinatra::Base
  include Mongo

  post '/services/reddit/submit/?' do
    content_type :json
    score = params[:score]
    raise InvalidParameters, "Missing score parameter" unless score

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

end

class InvalidParameters < Exception
end