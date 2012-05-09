require "sinatra/reloader" if development?
require './app'
run Sinatra::Application
