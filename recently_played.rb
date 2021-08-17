require "sinatra"
require "omniauth"
require "rspotify"
require "rspotify/oauth"
require "util"

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
      erb <<~EOS
        <form method='post' action='/auth/spotify'>
          <input type="hidden" name="authenticity_token" value='#{request.env["rack.session"]["csrf"]}'>
          <button type='submit'>Login with Spotify</button>
        </form>
      EOS
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
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
    <title>Spotify recently played</title>
  </head>
  <body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW" crossorigin="anonymous"></script>
    <main class="container">
      <div class="starter-template text-left py-5 px-3">
        <h1>Spotify recently played</h1>
        <%= yield %>
      </div>
    </main>
  </body>
</html>
