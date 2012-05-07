# coding: utf-8
require 'rubygems'
require 'sinatra'
require 'twitter'
#require 'pp'

before do
  Twitter.configure do |config|
    #config.proxy = 'http://proxy.gw.fujitsu.co.jp:8080'
    config.consumer_key       = 'ubtspgyKhPYFbC3iJjpPmQ' #ENV['CONSUMER_KEY']
    config.consumer_secret    = 'Le1qLZAEG5Gr5dgExqCm6YnsFtzIafehhZcwIS2byk' #ENV['CONSUMER_SECRET']
    config.oauth_token        = '83754646-sJKzDBfeE4Q4cJ52oRQ6GBdY3wZLzzt98Fnv6iI2U' #ENV['OAUTH_TOKEN']
    config.oauth_token_secret = 'sCzN4yGBTEFve5QTXC2g6t08iroKjHqSx3J45wMXXw' #ENV['OAUTH_TOKEN_SECRET']
  end
end

get '/' do
  'HerokuでSinatraのHello world!'
  prof = Twitter.user("gelegelebot")
  prof.screen_name
  ##pp prof
end

get '/latest' do
  Twitter.user_timeline("gelegelebot").first.text #直近のツイート
end

get '/tweet' do
  t = Time.now
  #Twitter.update("Heroku Sinatra Hello world! at #{t}")
  "tweet complete"
  "bye!"
end
