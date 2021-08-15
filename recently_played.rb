require "sinatra"
require "omniauth"
require "rspotify"
require "rspotify/oauth"
require "util"

OmniAuth.config.allowed_request_methods = [:post, :get]

$data = authenticate_from_config_yml

class MyApplication < Sinatra::Base
  use Rack::Session::Cookie

  use OmniAuth::Builder do
    provider :spotify, $data["client_id"], $data["client_secret"], scope: "user-read-email playlist-modify-public user-library-read user-library-modify"
  end

  get "/" do
    erb "<a href='/auth/spotify'>Login with Spotify</a><br>"
  end

  get "/auth/:provider/callback" do
    spotify_user = RSpotify::User.new(request.env["omniauth.auth"])
    # Now you can access user's private data, create playlists and much more

    result = request.env["omniauth.auth"]
    erb "<a href='/'>Top</a><br>
         <h1>#{params[:provider]}</h1>
         <pre>#{JSON.pretty_generate(result)}</pre>"
  end
end

MyApplication.run! if __FILE__ == $0
