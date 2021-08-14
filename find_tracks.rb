require "util"

authenticate_from_config_yml

ARGV.each do |query|
  tracks = RSpotify::Track.search(query)

  if ARGV.count > 1 && tracks.count > 1
    puts track_str(tracks[0])
  else
    tracks.each do |track|
      puts track_str(track)
    end
  end
end
