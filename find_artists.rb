require "rspotify"
require "yaml"

data = YAML.safe_load(File.read(".config.yml"))
RSpotify.authenticate(data["client_id"], data["client_secret"])

ARGV.each do |query|
  artists = RSpotify::Artist.search(query)

  if ARGV.count > 1 && artists.count > 1
    artist = artists[0]
    puts "#{artist.name} #{artist.popularity} #{artist.top_tracks(:JP)[0]&.name} #{artist.external_urls["spotify"]}"
  else
    artists.each do |artist|
      puts "#{artist.name} #{artist.popularity} #{artist.top_tracks(:JP)[0]&.name} #{artist.external_urls["spotify"]}"
    end
  end
end
