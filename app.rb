#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'sinatra'
require 'yaml'
require 'gateway.rb'

#g=Gateway.new()
#g.start()

@@globalpassword = YAML.load_file("config/config.yaml")["password"].to_s
puts @@globalpassword
get '/hi' do
  "Hello World!"
end

#get '/form' do
# File.read(File.join('public', 'massMsg.html'))
#end

# post is { message, key, numbers[] }
post '/form' do
  #"Hello Post!"
  @user = params[:user]
  @password = params[:key]
  @message = params[:message]
  @numbers = params[:numbers]
  if @password == @@globalpassword

    d = Dispatcher.new
    @numbers.each do |a|
      d.send(a,@message)
      puts a + " - "
    end
  end
end
