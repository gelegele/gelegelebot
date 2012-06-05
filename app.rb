# coding: utf-8
require 'rubygems'
require 'sinatra'
#require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'twitter'
require 'pp'
require 'cgi'
require 'logger'

use Rack::Session::Pool, :expire_after => 2592000 # enable :sessions に代わってセションの暗号化


#起動時１回だけ実行される
configure do
  Log = Logger.new(STDOUT)
  Twitter.configure do |config|
    if ENV["http_proxy"]
      config.proxy = ENV["http_proxy"]
      Log.info "config.proxy ==> " + config.proxy
    end
    config.consumer_key       = 'avKZ3NXholdRuw19bpt82A'
    config.consumer_secret    = 'KQm1lw9KdevEBwRi3WsYFhKmF2VRqbsN31AxgSX8'
    config.oauth_token        = '573594235-LEmaFKQ8jnWfZ9TGOslEC4Bt2pOE39wBMUxtt6gA'
    config.oauth_token_secret = '0nzp0btLR8jvrkln96if23Xih2D4UPMSa4d2uWPTlis'
  end
end


#イベント前に実行される
before do	
  @user_name = Twitter.user().screen_name
  Log.info "@user_name ==> " + @user_name

  #ページ番号
  if params[:page]
    @page = params[:page]
  else
    @page = 1
  end

end


#独自のスタイルシートはsassで定義
get '/style.css' do
  sass :stylesheet
end

#デフォルト
get '/' do
  redirect '/timeline'
end

#タイムライン
get '/timeline' do
  @time_line = Twitter.home_timeline({page:@page})
  haml :tab_timeline
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
  haml :tab_fav
end


#検索
get '/search' do
  if params[:keyword]
    if !params[:keyword].empty?
      @keyword = params[:keyword]
    else
      @keyword = nil
    end
    session[:keyword] = @keyword
  else
    @keyword = session[:keyword]
  end

  if @keyword
    @search_results = Twitter.search(
        CGI.escapeHTML(@keyword), {lang:'ja', rpp:30, page:@page})
    Log.info @search_results[0].pretty_inspect
  end
  haml :tab_search
end


#デバッグ用
get '/debug' do
  Log.info Twitter.user().pretty_inspect
  Twitter.user().screen_name
end
