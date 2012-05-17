# coding: utf-8
require 'rubygems'
require 'sinatra'
#require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'twitter'
require 'pp'
require 'cgi'

#起動時１回だけ実行される
configure do
  TWITTER_URL = "http://twitter.com/"
  Twitter.configure do |config|
    config.proxy = 'http://proxy.gw.fujitsu.co.jp:8080'
    config.consumer_key       = 'avKZ3NXholdRuw19bpt82A'
    config.consumer_secret    = 'KQm1lw9KdevEBwRi3WsYFhKmF2VRqbsN31AxgSX8'
    config.oauth_token        = '573594235-LEmaFKQ8jnWfZ9TGOslEC4Bt2pOE39wBMUxtt6gA'
    config.oauth_token_secret = '0nzp0btLR8jvrkln96if23Xih2D4UPMSa4d2uWPTlis'
  end
end


#イベント前に実行される
before do	
  @user_name = Twitter.user().screen_name
end


#独自のスタイルシートはsassで定義
get '/style.css' do
  sass :stylesheet
end


#タイムライン
get '/' do
  @time_line = Twitter.home_timeline()
  haml :index
end

#ツイートする
get '/tweet' do
  t = Time.now
  res = Twitter.update("Heroku Sinatra Hello world! at #{t}")
  p res.text #リダイレクト後にツイートが表示されるためのおまじない
  redirect '/'
end


#
get '/user' do
  pp Twitter.user()
  Twitter.user().screen_name
end


#検索
get '/search' do
  @raw_keyword = params[:keyword]
  if @raw_keyword && !@raw_keyword.empty? then
    @sanitized_keyword = CGI.escapeHTML(@raw_keyword) #サニタイズ
    @search_results = Twitter.search(@sanitized_keyword)
    pp @search_results[0]
  end
  haml :search
end
