class Application < Sinatra::Base

  get '/auth/google/callback' do
    session[:uid] = env['omniauth.auth']['uid']
    session[:fullname] = env['omniauth.auth']['info']['name']

    add_user_to_db env['omniauth.auth']

    #content_type 'text/plain'
    #request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
    redirect request.env['omniauth.origin'] || '/'
  end

  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end
end