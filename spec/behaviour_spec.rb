require 'spec_helper'

describe Behaviour do
  it "should have tests" do
    pending "write tests or I will kneecap you"
  end 

  describe ".pt_checkphoneid" do
    #vodafone_numbers = ["912345678","+351912345678"]
    it "should return vodafone when given 91 followed by 7 random digits" do
      Behaviour.pt_checkphoneid((910000000 + rand(9999999)).to_s).should eq("vodafone")
      
    end
    it "should return tmn when given 96 followed by 7 random digits" do
      Behaviour.pt_checkphoneid((960000000 + rand(9999999)).to_s).should eq("tmn")
    end
    it "should return tmn when given 92 followed by 7 random digits" do
      Behaviour.pt_checkphoneid((920000000 + rand(9999999)).to_s).should eq("tmn")
    end
    it "should return optimus when given 93 followed by 7 random digits" do
      Behaviour.pt_checkphoneid((930000000 + rand(9999999)).to_s).should eq("optimus")
    end
  end
end

