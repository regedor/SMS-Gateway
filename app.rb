require 'rubygems'
require 'sinatra'
require 'yaml'

get '/hi' do
  "Hello World!"
end

get '/form' do
  File.read(File.join('public', 'massMsg.html'))
end

#direct get 
#get '/single/:numero/:msg' do
#  @numero = params[:numero]
#  @msg = params[:msg]
#  @numero + ': ' + @msg
  
#end

# post is { message , numbers[] }
post '/form' do
  #"Hello Post!"
  @message = params[:message]
  @callsign = params[:callsign]
  @numbers = params[:numbers]

  if @callsign == "gbuddiescalli"
    @numbers.each do |a|
     `./gateway.rb #{a} "#{@message}"`
     puts a + "\n"
    end
  end
end

#post '/post' do
#  params[:numero]
#  params[:txt]
#end
