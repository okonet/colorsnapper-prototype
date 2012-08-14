# -*- encoding : utf-8 -*-
require 'rubygems'
require 'sinatra'
require 'erb'

class Application < Sinatra::Base
  # set sinatra's variables
  set :app_file, __FILE__
  set :root, File.dirname(__FILE__)
  set :views, "views"

  get '/' do
    erb :index
  end

end
