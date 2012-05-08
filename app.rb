# coding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'twitter'
require 'pp'

before do	
  Twitter.configure do |config|
    config.proxy = 'http://proxy.gw.fujitsu.co.jp:8080'
    config.consumer_key       = 'avKZ3NXholdRuw19bpt82A' #ENV['CONSUMER_KEY']
    config.consumer_secret    = 'KQm1lw9KdevEBwRi3WsYFhKmF2VRqbsN31AxgSX8' #ENV['CONSUMER_SECRET']
    config.oauth_token        = '573594235-LEmaFKQ8jnWfZ9TGOslEC4Bt2pOE39wBMUxtt6gA' #ENV['OAUTH_TOKEN']
    config.oauth_token_secret = '0nzp0btLR8jvrkln96if23Xih2D4UPMSa4d2uWPTlis' #ENV['OAUTH_TOKEN_SECRET']
  end
end

get '/' do
  @user_name = Twitter.user().screen_name
  @time_line = Twitter.user_timeline()
  haml :index
end

get '/tweet' do
  t = Time.now
  Twitter.update("Heroku Sinatra Hello world! at #{t}")
  "tweet complete"
end





#スタイルシートをsassで定義してみた
get '/style.css' do
  sass :stylesheet
end
#sassを使っったページ
get '/timeline' do
  @time_line = Twitter.user_timeline()
  haml :timeline
end

