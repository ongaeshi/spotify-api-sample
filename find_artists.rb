require "rspotify"
require "yaml"

data = YAML.safe_load(File.read(".config.yml"))
RSpotify.authenticate(data["client_id"], data["client_secret"])

ARGV.each do |query|
  artists = RSpotify::Artist.search(query)

  artists.each do |artist|
    # p artist
    # p artist.top_tracks(:JP)
    puts "#{artist.name} #{artist.popularity} #{artist.external_urls["spotify"]}"
  end
end
