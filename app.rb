# coding: utf-8
require 'rubygems'
require 'sinatra'
#require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'twitter'
require 'pp'
require 'cgi'

use Rack::Session::Pool, :expire_after => 2592000 # enable :sessions に代わってセションの暗号化


#起動時１回だけ実行される
configure do
  Twitter.configure do |config|
    config.proxy = 'http://' + ENV["http_proxy"] if ENV["http_proxy"]
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
  haml :timeline
end

#ツイートする
get '/tweet' do
  t = Time.now
  res = Twitter.update("Heroku Sinatra Hello world! at #{t}")
  p res.text #リダイレクト後にツイートが表示されるためのおまじない
  redirect '/'
end

#お気に入り
get '/fav' do
  #@favs = Twitter.favorites(Twitter.user().name)
  @fav_user_name = "gelegele"
  @favs = Twitter.favorites(@fav_user_name)
  haml :fav
end


#検索
get '/search' do
  if params[:keyword] then 
    if !params[:keyword].empty? then
      @keyword = params[:keyword]
    else
      @keyword = nil
    end
    session[:keyword] = @keyword
  else
    @keyword = session[:keyword]
  end

  if @keyword then
    @search_results = Twitter.search(CGI.escapeHTML(@keyword))
    pp @search_results[0]
  end
  haml :search
end


#デバッグ用
get '/debug' do
  pp Twitter.user()
  Twitter.user().screen_name
end
