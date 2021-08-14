require "util"

authenticate_from_config_yml

ARGV.each do |query|
  artists = RSpotify::Artist.search(query)

  if ARGV.count > 1 && artists.count > 1
    puts artist_str(artists[0])
  else
    artists.each do |artist|
      puts artist_str(artist)
    end
  end
end
