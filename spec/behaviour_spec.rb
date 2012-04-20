require 'spec_helper'

describe Behaviour do
  valid_options = {
    "phone"    => "vodafone",
    "tmn"      => "1500D",
    "optimus"  => "1500W",
    "vodafone" => "1500W",
    "phones"   => {
      "359419001297612" => "vodafone",
      "359419001303212" => "tmn",
      "356479007544261" => "optimus"
   }
  }

  describe ".pt_checkphoneid" do
  #success
    ["1234567","8901234"].each do |number|
      ["+351",""].each do |prefix|
        it "should return vodafone when given #{prefix}91#{number}" do
          Behaviour.pt_checkphoneid(prefix + "91" + number ).should eq("vodafone")
        end
        it "should return tmn when given #{prefix}96#{number}" do
          Behaviour.pt_checkphoneid(prefix + "96" + number ).should eq("tmn")
        end
        it "should return tmn when given #{prefix}92#{number}" do
          Behaviour.pt_checkphoneid(prefix + "92" + number ).should eq("tmn")
        end
    it "should return optimus when given #{prefix}93#{number}" do
          Behaviour.pt_checkphoneid(prefix + "93" + number ).should eq("optimus")
        end
      end
    end
  #failure
    it "should return invalid number when given number with more than 9 digits after prefix 9123456999" do
      Behaviour.pt_checkphoneid("9123456999").should eq("Invalid Number")
    end
    it "should return invalid number when given number with less than 9 digits after prefix 91234569" do
      Behaviour.pt_checkphoneid("91234569").should eq("Invalid Number")
    end

    it "should return invalid number when given number with invalid operator id 951234567" do
      Behaviour.pt_checkphoneid("951234567").should eq("Invalid Number")
    end
  end

  describe ".pt_single" do
    it "should return phone set in options as sender, if number is valid pt number" do
      Behaviour.pt_single("912345678",valid_options).should eq(valid_options['phone'])
    end
    it "should return Invalid Phone in config if given invalid option" do
      invalid_options = valid_options
      invalid_options.store("phone","tmen")
      Behaviour.pt_single("912345678",invalid_options).should eq("Invalid Phone in config")
    end
  end

  describe ".pt_default" do  
    it "should receive valid phone from checkphoneid" do
    #pending "needs better syntax"
      Behaviour.pt_default("912345678",valid_options).should eq(Behaviour.pt_checkphoneid("912345678"))
    end
  end
end
