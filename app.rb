#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'sinatra'
require 'yaml'
require 'gateway.rb'

g = Gateway.new()
g.phoneloader
g.start

@@users = YAML.load_file("config/config.yaml")
@@phones= Hash["359419001297612","voda","359419001303212","tmn","356479007544261","opti"]

#get '/hi' do
  
#end

get '/form' do
 File.read(File.join('public', 'massMsg.html'))
end

# post is {user, key, message, numbers[]}
post '/form' do
  @user = params[:user]
  @password = params[:key]
  @message = params[:message]
  @numbers = params[:numbers]
  if @@users['password']==@password && @@users['user']==@user
    d = Dispatcher.new
    @numbers.each do |a|
      phoneid = d.checkphoneid(a)
      if @@phones.values.include?(phoneid)
           d.send(a,@message,@user)
      else
          puts "Invalid Number"
      end
    end
  end
end
