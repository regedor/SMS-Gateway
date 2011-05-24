#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'sinatra'
require 'yaml'
require 'gateway.rb'

get '/hi' do
  "Hello World!"
end

get '/form' do
  File.read(File.join('public', 'massMsg.html'))
end

# post is { message, key, numbers[] }
post '/form' do
  #"Hello Post!"
  @message = params[:message]
  @key = params[:key]
  @numbers = params[:numbers]

  if @key == "gbuddiescall"
    d = Dispatcher.new()
    @numbers.each do |a|
     d.send(a,@message)
     puts a + "\n"
    end
  end
end
