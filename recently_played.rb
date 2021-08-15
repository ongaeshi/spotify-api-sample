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
    provider :spotify, $data["client_id"], $data["client_secret"], scope: "user-read-recently-played"
  end

  get "/" do
    erb "<a href='/auth/spotify'>Login with Spotify</a><br>"
  end

  get "/auth/:provider/callback" do
    user = RSpotify::User.new(request.env["omniauth.auth"])
    recently_played = user.recently_played(limit: 50)

    erb "<a href='/'>Top</a><br>
         <h1>Spotify recently played</h1>
         <pre>#{recently_played.map { |e| track_str(e)}.join("\n")}</pre>"
  end
end

MyApplication.run! if __FILE__ == $0
