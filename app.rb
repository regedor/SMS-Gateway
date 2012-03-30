#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'sinatra'
require 'yaml'

require 'gateway.rb'

@config  = YAML.load_file("config/config.yml")
@gateway = Gateway.new @config

# post is {user, key, message, numbers[]}
post '/form' do
  user = @config['users'][params[:user]]
  return "Invalid User" unless user
  return(if user['password'] == params[:key]
    params[:numbers].each do |number|       
      if @gateway.send(user, number, params[:message])
        "Sent"
      else
        "Invalid Number"
      end
    end
  else 
    "Invalid Password"
  end)
end

get '/form' do
  File.read(File.join('public', 'massMsg.html'))
end
