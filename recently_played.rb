require "sinatra"
require "omniauth"
require "rspotify"
require "rspotify/oauth"
require "util"

OmniAuth.config.allowed_request_methods = [:post, :get]

$data = authenticate_from_config_yml

class MyApplication < Sinatra::Base
  configure do
    set :sessions, true
    set :inline_templates, true
  end

  use OmniAuth::Builder do
    provider :spotify, $data["client_id"], $data["client_secret"], scope: "user-read-recently-played"
  end

  get "/" do
    if session[:authenticated]
      user = RSpotify::User.new(session[:omniauth_auth])
      recently_played = user.recently_played(limit: 50)

      erb <<~EOS
        #{recently_played_html(recently_played)}
        <a href="/logout">Logout</a><br>
      EOS
    else
      erb "<a href='/auth/spotify'>Login with Spotify</a><br>"
    end
  end

  get "/auth/:provider/callback" do
    session[:authenticated] = true
    session[:omniauth_auth] = request.env["omniauth.auth"]
    redirect "/"
  end

  get "/logout" do
    session[:authenticated] = false
    redirect "/"
  end

  def recently_played_html(recently_played)
    body = recently_played.map do |track|
      "<li>#{track_html(track)}</li>"
    end.join("\n")

    <<~EOS
      <ol>
        #{body}
      </ol>
    EOS
  end
end

MyApplication.run! if __FILE__ == $0


__END__

@@ layout
<html>
  <h1>Spotify recently played</h1>
  <%= yield %>
</html>
