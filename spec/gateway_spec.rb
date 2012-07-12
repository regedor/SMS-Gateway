require 'spec_helper'

describe Gateway do  
  valid_args = {
    "phones" => { 
      "359419001297612" => "vodafone",
      "359419001303212" => "tmn",
      "356479007544261" => "optimus"},
    "ports"      => "ttyACM0;ttyACM1;ttyACM2",
    "datafolder" => "./tmp/",
    "users"      => {
      "username"        => "testname"
    }
  }
  
  
  valid_args_single = {
    "phones" => { 
      "359419001297612" => "vodafone",
      "359419001303212" => "tmn",
      "356479007544261" => "optimus"},
    "ports"      => "ttyACM0;ttyACM1;ttyACM2",
    "datafolder" => "./tmp/",
    "behaviour"  => {
      "type"            => "pt_single",
      "phone"           => "vodafone"}
  } 

  invalid_args_wrong_path_to_datafolder = {
    "phones" => { 
      "359419001297612" => "vodafone",
      "359419001303212" => "tmn",
      "356479007544261" => "optimus"
    },
    "ports"      => "ttyACM0;ttyACM1;ttyACM2",
    "datafolder" => "./"
  }
 
  def factory_valid_gateway_without_gammu_started
    valid_args = {
      "phones" => { 
        "359419001297612" => "vodafone",
        "359419001303212" => "tmn",
        "356479007544261" => "optimus"
      },
      "ports"      => "ttyACM0;ttyACM1;ttyACM2",
      "datafolder" => "./tmp/"
    }

    Gateway.new valid_args, :initialize_gammu => false
  end

  def factory_clean_tmp_folder
  
  end
  
  
  describe ".new" do
    it "should raise ArgumentError if options dont include phones and ports" do
      expect{ Gateway.new({}) }.to raise_error(ArgumentError)
    end
    
    it "it should start and load the necessary stuff" do
      Gateway.any_instance.should_receive(:phoneloader).once
      Gateway.any_instance.should_receive(:start).once
      Gateway.new(valid_args) 
    end
    it "it should start and NOT load the necessary stuff if option :initialize_gammu is false" do
      Gateway.any_instance.should_not_receive(:phoneloader)
      Gateway.any_instance.should_not_receive(:start)
      factory_valid_gateway_without_gammu_started
    end
  end
  
  describe "#phoneloader" do
    subject { factory_valid_gateway_without_gammu_started }

    it "should raise Error if file is not in given datafolder" do
      g = Gateway.new invalid_args_wrong_path_to_datafolder , :initialize_gammu => false
      expect { g.phoneloader }.to raise_error()
    end

    it "should read gammu config file" do
      pending "check file not being read"
      IO.should_receive(:read).with("./tmp/gammu-smsdrc")
      subject.phoneloader
    end
    #subject{ Gateway.new valid_args}
    it "should run gammu detect to port and return valid IMEI if exists" do
      pending "incomplete test"
      #g = factory_valid_gateway_without_gammu_started
      subject.should_receive(:`).with("gammu -c ./tmp/ttyACM0 --identify | grep IMEI")
      subject.phoneloader
       
      
    end
    
    it "should read example gammu-smsd config file to a template" do
      pending "no tests yet"  
    end

    #valid_args[:ports]
    # "ttyACM0;ttyACM1;ttyACM2".split(";").each do |port|
    port = "ttyACM0"
      it "should send system call to delete temporary config from port: #{port} from ./tmp/" do
        #pending "Incomplete test"
        #g = factory_valid_gateway_without_gammu_startedi
        "ttyACM0;ttyACM1;ttyACM2".split(";").each do |port|
         subject.should_receive("system").with("rm ./tmp/" + port)
        end
        subject.phoneloader
      end
    #end
    

    


  end
  
 
 describe "start" do
   subject { Gateway.new valid_args }
   it "should send system call to kill gammu processes" do
     #pending "system call test incomplete"
     subject.should_receive(:'`').with("killall gammu-smsd")
     subject.start
     
   end
   it "should fork to new gammu-smsd process" do
     #pending "system call test incomplete"
     #g= Gateway.new valid_args
     subject.should_receive(:fork).at_least(1).times
     subject.start
   end

 end
 
 describe "#send" do
   it "should go get a phone from Behaviour if no phone is given" do
     pending "incomplete"
     #g = factory_valid_gateway_without_gammu_started
     subject.should_receive("Behaviour.select_phone").with("912345678") # if valid_args[:phone].nil?
     #Behaviour.should_receive("select_phone")
     subject.send(valid_agrs[:users[:username]],"912345678","test message")
   end 
 end
end
