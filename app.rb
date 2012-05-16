# coding: utf-8
require 'rubygems'
require 'sinatra'
#require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'twitter'
require 'pp'
require 'cgi'

#イベント前に実行される
before do	
  Twitter.configure do |config|
    #config.proxy = 'http://proxy.gw.fujitsu.co.jp:8080'
    config.consumer_key       = 'avKZ3NXholdRuw19bpt82A'
    config.consumer_secret    = 'KQm1lw9KdevEBwRi3WsYFhKmF2VRqbsN31AxgSX8'
    config.oauth_token        = '573594235-LEmaFKQ8jnWfZ9TGOslEC4Bt2pOE39wBMUxtt6gA'
    config.oauth_token_secret = '0nzp0btLR8jvrkln96if23Xih2D4UPMSa4d2uWPTlis'
  end
  @user_name = Twitter.user().screen_name
end

#独自のスタイルシートはsassで定義
get '/style.css' do
  sass :stylesheet
end

get '/' do
  @time_line = Twitter.home_timeline()
  haml :index
end

get '/tweet' do
  t = Time.now
  res = Twitter.update("Heroku Sinatra Hello world! at #{t}")
  p res.text #リダイレクト後にツイートが表示されるためのおまじない
  redirect '/'
end

get '/search' do
  param_word = CGI.escapeHTML(params[:word]) #サニタイズ
  if !param_word || param_word.empty? then
    haml :search_default
  else
    @search_word = param_word
    @search_results = Twitter.search(@search_word)
    haml :search
  end
end


#仮：sassを使っったページ
get '/sass' do
  @time_line = Twitter.user_timeline()
  haml :sass_view, :layout => false
end

