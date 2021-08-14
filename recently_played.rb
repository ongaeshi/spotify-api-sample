require "sinatra"
require "omniauth"

class MyApplication < Sinatra::Base
  use Rack::Session::Cookie
  use OmniAuth::Strategies::Developer
end

get "/" do
  "hi"
end
