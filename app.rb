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
  @key = params[:key]
  @numbers = params[:numbers]

  if @key == "gbuddiescall"
    @numbers.each do |a|
     `./gateway.rb #{a} "#{@message}"`
     puts a + "\n"
    end
  end
  "No."
end

#post '/post' do
#  params[:numero]
#  params[:txt]
#end
