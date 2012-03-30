require 'spec_helper'

describe Behaviour do
  it "should have tests" do
    pending "write tests or I will kneecap you"
  end 

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
    it "should return invalid number when given number with more or less than 9 digits after prefix 9123456999" do
      Behaviour.pt_checkphoneid("9123456999").should eq("Invalid Number")
    end
    it "should return invalid number when given number with invalid operator id 951234567" do
      Behaviour.pt_checkphoneid("951234567").should eq("Invalid Number")
    end
  end
end
