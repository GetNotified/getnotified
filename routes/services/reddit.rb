class Application < Sinatra::Base
  include Mongo

  post '/services/reddit/frontpage/submit/?' do
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

  post '/services/reddit/submission/submit/?' do
    content_type :json
    save_user_notification(params, 'user-submission')
  end

  post '/services/reddit/comment/submit/?' do
    content_type :json
    save_user_notification(params, 'user-comment')
  end

  post '/services/reddit/subalert/submit/?' do
    content_type :json
    save_subreddit_notification(params, 'subreddit-alert')
  end

  def save_subreddit_notification(params, type)
    score      = params[:score]
    subreddit  = params[:subreddit]

    uid = session[:uid]
    unless uid
      return {success: 'false',
              error: 'You need to log in first'}.to_json
    end

    if score.empty? or subreddit.empty?
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    score = score.to_i

    requests_coll = settings.mongo_db.collection("requests")
    notifications_coll = settings.mongo_db.collection("notifications")

    # Will insert if doesn't already exist
    requests_coll.update({type: type, service: 'reddit', subreddit: subreddit},
                         {
                             service: 'reddit',
                             type: type,
                             subreddit: subreddit,
                             last_id: 'none'
                         },
                         {upsert: true})

    notifications_coll.update({uid: uid, type: type, subreddit: subreddit},
                              {
                                  uid: uid,
                                  service: 'reddit',
                                  type: type,
                                  subreddit: subreddit,
                                  score: score,
                              },
                              {upsert: true})
    # Executed successfully
    {success: 'true'}.to_json
  end

  def save_user_notification(params, type)
    score = params[:score]
    user  = params[:user]

    uid = session[:uid]
    unless uid
      return {success: 'false',
              error: 'You need to log in first'}.to_json
    end

    if score.empty? or user.empty?
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    score = score.to_i

    requests_coll = settings.mongo_db.collection("requests")
    notifications_coll = settings.mongo_db.collection("notifications")

    # Will insert if doesn't already exist
    requests_coll.update({type: type, service: 'reddit', username: user},
                         {
                             service: 'reddit',
                             type: type,
                             username: user,
                             last_id: 'none'
                         },
                         {upsert: true})

    notifications_coll.update({uid: uid, type: type, username: user},
                          {
                              uid: uid,
                              service: 'reddit',
                              type: type,
                              username: user,
                              score: score,
                          },
                          {upsert: true})
    # Executed successfully
    {success: 'true'}.to_json
  end
end