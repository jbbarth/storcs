require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Storcs::Parsers::Ibm do
  it "divides a profile file into small sections" do
    sections = Storcs::Parsers::Ibm.new('spec/data/ibm_DS4500.txt').sections
    sections.should be_a Hash
    sections.keys.length.should == 11
    sections[:arrays].should be_an Array
  end

  it "returns a list of arrays with name+raid type" do
    arrays = Storcs::Parsers::Ibm.new('spec/data/ibm_DS4500.txt').arrays
    arrays.length.should == 15
    first = arrays.first
    first.should be_a Storcs::Device
    first.name.should == "ARRAY 1"
    first.raid.should == "5"
  end

  it "parses the output of a 'SMcli X.X.X.X 'show storagesubsystem profile;'" do
    parsed = Storcs::Parsers::Ibm.new('spec/data/ibm_DS4500.txt')
    bay = parsed.device
    bay.should_not be_nil
    arrays = bay.children
    arrays.length.should == 15
    #bay.used.should == 598024
    #bay.size.should == 795481
    #bay.free.should == 197457
  end
end
