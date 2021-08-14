# Spotify API Sample
## Install
```
$ git checkout https://github.com/ongaeshi/spotify-api-sample.git
$ cd spotify-api-sample
$ bundle install
```

## Find artists
```
$ bundle exec ruby "Taylor Swift"
PS C:\Users\ongaeshi\Code\spotify-api-sample> bundle exec ruby .\find_artists.rb "Taylor Swift"
Taylor Swift 96 Blank Space https://open.spotify.com/artist/06HL4z0CvFAxyc27GXpf02
Taylor Swiftman 9 Love for Live https://open.spotify.com/artist/5WiLThuSBwqF7SMRrzQbG6
Swift Taylor 0  https://open.spotify.com/artist/3z2P5DW0J7Pceqe8miT2tT
```

```
$ bundle exec ruby "Taylor Swift" 星野源 Coldplay
PS C:\Users\ongaeshi\Code\spotify-api-sample> bundle exec ruby .\find_artists.rb "Taylor Swift"
Taylor Swift 96 Blank Space https://open.spotify.com/artist/06HL4z0CvFAxyc27GXpf02
Taylor Swiftman 9 Love for Live https://open.spotify.com/artist/5WiLThuSBwqF7SMRrzQbG6
Swift Taylor 0  https://open.spotify.com/artist/3z2P5DW0J7Pceqe8miT2tT
```