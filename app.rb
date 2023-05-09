# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return "<h1>Hello World!</h1>"
  end
end