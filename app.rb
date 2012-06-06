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

use Rack::Session::Pool, :expire_after => 2592000 # instead of "enable :sessions" to encrypt


# at start
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


# at event
before do	
  @user_name = Twitter.user().screen_name
  Log.info "@user_name ==> " + @user_name

  # page no
  if params[:page]
    @page = params[:page]
  else
    @page = 1
  end

end


get '/style.css' do
  sass :stylesheet
end

# default is redirected to timeline
get '/' do
  redirect '/timeline'
end

get '/timeline' do
  @time_line = Twitter.home_timeline({page:@page})
  haml :tab_timeline
end

get '/tweet' do
  t = Time.now
  res = Twitter.update("Heroku Sinatra Hello world! at #{t}")
  p res.text # Is this needed?
  redirect '/'
end

get '/fav' do
  #@favs = Twitter.favorites(Twitter.user().name)
  @fav_user_name = "gelegele"
  @favs = Twitter.favorites(@fav_user_name)
  haml :tab_fav
end


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


# debugger
get '/debug' do
  Log.info Twitter.user().pretty_inspect
  Twitter.user().screen_name
end
