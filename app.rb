# coding: utf-8
require 'rubygems'
require 'sinatra'
# require 'sinatra/reloader' if development?
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
    Log.error "CONSUMER_KEY" unless ENV['CONSUMER_KEY']
    # ENV['CONSUMER_SECRET']       
    # ENV['OAUTH_TOKEN']
    # ENV['OAUTH_TOKEN_SECRET']
    config.consumer_key       = ENV['CONSUMER_KEY']
    config.consumer_secret    = ENV['CONSUMER_SECRET']
    config.oauth_token        = ENV['OAUTH_TOKEN']
    config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
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
  @time_line = Twitter.home_timeline({:page=>@page})
  haml :tab_timeline
end

get '/tweet' do
  haml :tab_tweet
end

post '/tweet' do
  tweet_text = params[:text].strip
  if tweet_text.empty?
    haml :tab_tweet
    return
  end
  res = Twitter.update(tweet_text)
  redirect '/timeline'
end

get '/autotweet' do
  t = Time.now
  res = Twitter.update("Heroku Sinatra Hello world! at #{t}")
end

get '/fav' do
  #@favs = Twitter.favorites(Twitter.user().name)
  @favs = Twitter.favorites(@user_name)
  haml :tab_fav
end

post '/favorite' do
  Twitter.favorite(params[:id])
end

post '/unfavorite' do
  Twitter.unfavorite(params[:id])
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
        CGI.escapeHTML(@keyword), {:lang=>'ja', :rpp=>30, :page=>@page})
    Log.info @search_results[0].pretty_inspect
  end
  haml :tab_search
end

get '/activity' do
  pp Twitter.activity_about_me
  #pp Twitter.activity_by_friends
end

# debugger
get '/debug' do
  Log.info Twitter.user().pretty_inspect
  Twitter.user().screen_name
end
