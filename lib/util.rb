require "rspotify"
require "yaml"

def authenticate_from_config_yml
  data = YAML.safe_load(File.read(".config.yml"))
  RSpotify.authenticate(data["client_id"], data["client_secret"])
end

def artist_str(artist)
  "#{artist.name} #{artist.popularity} #{artist.top_tracks(:JP)[0]&.name} #{artist.external_urls["spotify"]}"
end