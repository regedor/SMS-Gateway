require 'spec_helper'

describe Gateway do  
  valid_args = {
    "phones" => { 
      "359419001297612" => "vodafone",
      "359419001303212" => "tmn",
      "356479007544261" => "optimus"},
    "ports"      => "ttyACM0;ttyACM1;ttyACM2",
    "datafolder" => "./tmp/"
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
      "356479007544261" => "optimus"},
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
    
    it "it should start load the necessary stuff" do
      Gateway.any_instance.should_receive(:phoneloader).once
      Gateway.any_instance.should_receive(:start).once
      Gateway.new(valid_args) 
    end
    it "it should start not load the necessary stuff if option :initialize_gammu is false" do
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

    it "should run gammu detect to port and return valid IMEI if exists" do
      #pending "incomplete test"
      #g = factory_valid_gateway_without_gammu_started
      subject.should_receive(:`).with("gammu -c ./tmp/ttyACM0 --identify | grep IMEI")
      subject.phoneloader
       
      
    end
    
    it "should read example gammu-smsd config file to a template" do
      pending "no tests yet"  
    end

    #valid_args[:ports]
    "ttyACM0;ttyACM1;ttyACM2".split(";").each do |port|
      it "should send system call to delete temporary config from port: #{port} from ./tmp/" do
        pending "Incomplete test"
        #g = factory_valid_gateway_without_gammu_started
        subject.should_receive("system").with("rm ./tmp/" + port)
        subject.phoneloader
      end
    end
    

    


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
    it "should go get a phone from Behaviour" do
      pending "incomplete"
      g = factory_valid_gateway_without_gammu_started
      g.should_receive("Behaviour.select_phone") if valid_args[:phone].nil?
    end 
  end

 # # should respond_to .method with 1 argument
 # %w{h1 h2 h3 h4 h5 p notice warning error}.each do |method|
 #   it { should respond_to(method).with(1).argument } 
 # end

 # 
 # # .h1*(str) should output
 # %w{h1 h2 h3 h4 h5 p notice warning error debug}.each do |method|
 #   ["text", "coisas loucas", "pumba\npumba"].each do |text|
 #     it ".#{method}(#{text.inspect}) should output #{text.inspect} (case insensitive)" do
 #       Polvo::Printer.send method, text
 #       @output.should =~ /#{text}/i
 #     end
 #   end
 # end
 # 
 # # .h1*(str) should capitalize
 # %w{h1 h2 h3 h4 h5}.each do |method|
 #   {"mouse" => "MOUSE"}.each do |input, output|
 #     it ".#{method}(#{input.inspect}) should output #{output.inspect}" do
 #       Polvo::Printer.send method, input
 #       @output.should =~ /#{output}/
 #     end
 #   end
 # end
 #  
 # # .wait(text) show text and do a gets" do
 # it ".wait(text) show text and do a gets" do
 #   text = "warning message"
 #   $stdin.should_receive(:gets).once
 #   subject.wait(text)
 #   @output.should =~ /#{text}/
 # end
 # 
 # # .confirm(question) should return true/false when user answers yes/no " do
 # {"yes"=> true, "y" => true, "YES" => true, "Y" => true,
 #  "no" => false,"n" => false,"NO" => false, "N" => false}.each do |answer, value|
 #   it ".confirm should return #{value} when user answers '#{answer}' " do
 #     question = "Queres bananas?"
 #     $stdin.should_receive(:gets).and_return(answer)
 #     subject.confirm(question).should == value
 #   end
 # end
 # 
 # 
 # it "should have the method ask that returns the user input" do
 #   question, answer = "Queres bananas?", "Sim"
 #   $stdin.should_receive(:gets).and_return(answer)
 #   $stdout.should_receive(:write).with("\n#{question}")
 #   subject.ask(question).should == answer  
 # end
 # 
 # describe ".menu" do
 #   subject {Polvo::Printer}
 #   items          = ["Option 1","Option 2","Option 3","Option 4"]
 #   valid_answer   = "3"
 #   invalid_answer = "7"
 #   
 #   it "should not acept invalid answer" do
 #     $stdin.should_receive(:gets).and_return(invalid_answer,valid_answer)
 #     subject.menu(items).should == valid_answer
 #   end
 #   
 #   it "should acept invalid answer if extended_option is true" do
 #     $stdin.should_receive(:gets).and_return(invalid_answer)
 #     subject.menu(items, :extended_option => true).should == invalid_answer
 #   end
 #   
 #   it "should have more tests" do
 #     pending "write tests or I will kneecap you"
 #   end
 #   
 # end
 # 
 # it ".clear should have tests" do
 #   pending "write tests or I will kneecap you"
 # end

end

