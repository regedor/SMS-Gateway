require 'spec_helper'
require 'rack/test'
require File.dirname(__FILE__) + '/../app.rb'

set :environment, :test

def app
  Sinatra::Application
end

describe "SMS Gateway" do
  include Rack::Test::Methods

  it "should show form on get" do
    get '/form'
    last_response.should be_ok
  end
  it "should call gateway" do
    pending "moar tests darnit!"
  end
  it "should return invalid user if user does not exist, after loading everything" do
    pending "incomplete"
    post '/form' , params={ :user => "testname" }
    last_response.body.should == 'Invalid User' 
    
  end
end
