class Application < Sinatra::Base
  include HTTParty
  helpers do
    def logged_in?
      !session[:uid].nil? and !session[:fullname].nil?
    end

    def authenticate
      # we do not want to redirect to Google when the path info starts
      # with /auth/
      pass if request.path_info =~ /^\/auth\//

      # /auth/google is captured by omniauth:
      redirect to('/auth/google') unless logged_in?
    end

    def add_user_to_db(info)
      users_coll = settings.mongo_db.collection("users")
      users_coll.update({uid: info['uid']},
                         {
                           "$set" => {
                            uid:       info['uid'],
                            fullname:  info['info']['name'],
                            email:     info['info']['email'],
                            image:     info['info']['image'],
                            credentials:
                                {
                                    auth_type:     info['provider'],
                                    token:         info['credentials']['token'],
                                    refresh_token: info['credentials']['refresh_token'],
                                    expires_at:    info['credentials']['expires_at'],
                                }
                           }
                         },
                         {upsert: true})

    end

    def send_android_push(regId, body)
      post('https://notifyme-push.azure-mobile.net/api/android',
           query: { regId: regId, body: body },
           headers: { "X-ZUMO-APPLICATION" => CONFIG['AZURE_API_SECRET'] }
      )
    end

    def find_user_by_uid(uid)
      users_coll = settings.mongo_db.collection("users")
      users_coll.find_one({uid: uid})
    end

    def find_notifications_by_uid(uid)
      notifications_coll = settings.mongo_db.collection("notifications")
      notifications_coll.find({uid: uid}).to_a
    end

    def is_admin?(uid)
      users_coll = settings.mongo_db.collection("users")
      user = users_coll.find_one({uid: uid})
      user['is_admin']
    end

    def latest_notifications_sent
      notifications_coll = settings.mongo_db.collection("logs")
      notifications_coll.find().limit(20)
    end

    def notifications_count
      # These values need to be cached
      settings.mongo_db.collection("notifications").count
    end

    def notifications_sent_count
      # These values need to be cached
      settings.mongo_db.collection("logs").count
    end

    def users_count
      # These values need to be cached
      settings.mongo_db.collection("users").count
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