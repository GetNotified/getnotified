class Application < Sinatra::Base
  include Mongo

  post '/services/github/repo-watch/submit/?' do
    content_type :json
    user  = params[:user]
    repo  = params[:repo]
    action = params[:action]

    uid = session[:uid]
    unless uid
      return {success: 'false',
              error: 'You need to log in first'}.to_json
    end

    if user.empty? or repo.empty?
      return {success: 'false',
              error: 'Missing parameters'}.to_json
    end

    type = 'github-repo-watch'

    requests_coll = settings.mongo_db.collection("requests")
    notifications_coll = settings.mongo_db.collection("notifications")

    # Will insert if doesn't already exist
    requests_coll.update({type: type, username: user, repo: repo},
                         {
                             service: 'github',
                             type: type,
                             user: user,
                             repo: repo
                         },
                         {upsert: true})

    notifications_coll.update({uid: uid, type: type, username: user, repo: repo, action: action},
                              {
                                  uid: uid,
                                  service: 'github',
                                  type: type,
                                  user: user,
                                  repo: repo,
                                  action: action
                              },
                              {upsert: true})
    # Executed successfully
    {success: 'true'}.to_json
  end
end