require "rspotify"
require "yaml"
require "time"

def authenticate_from_config_yml
  data = YAML.safe_load(File.read(".config.yml"))
  RSpotify.authenticate(data["client_id"], data["client_secret"])
  data
end

def artist_str(artist)
  "#{artist.name} #{artist.popularity} #{artist.top_tracks(:JP)[0]&.name} #{artist.external_urls["spotify"]}"
end

def track_str(track)
  artist = track.artists[0]
  "#{track.name} - #{artist.name} #{ms_to_time(track.duration_ms)} #{track.popularity} #{track.external_urls["spotify"]}"
end

def track_html(track)
  image_url = track.album.images[2]["url"]
  album_url = track.album.external_urls["spotify"]
  artist = track.artists[0]
  "<a href='#{album_url}'><img src='#{image_url}' /></a> <a href='#{track.external_urls["spotify"]}'>#{track.name}</a> #{artist.name} #{ms_to_time(track.duration_ms)}"
end

def ms_to_time(ms)
  sec = ms / 1000
  day = sec.to_i / 86400
  (Time.parse("1/1") + (sec - day * 86400)).strftime("%M:%S")
end
