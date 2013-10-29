class Application < Sinatra::Base

  get '/auth/google/callback' do
    session[:uid] = env['omniauth.auth']['uid']
    #content_type 'text/plain'
    #request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
    redirect request.env['omniauth.origin'] || '/'
  end

  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end
end