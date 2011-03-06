require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Storcs::Parsers::Ibm do
  it "parses the output of a 'SMcli X.X.X.X show storagesubsystem profile;'" do
    parsed = Storcs::Parsers::Ibm.new('ds4500','spec/data/ibm_DS4500.txt')
    bay = parsed.device
    bay.should_not be_nil
    bay.name.should == "ds4500"
    arrays = bay.children
    arrays.length.should == 15
    bay.size.should == 12285713148014
    bay.used.should == 11460324586680
    bay.free.should == 825388561334
    bay.unassigned.should == 731389980835
  end

  it "divides a profile file into small sections" do
    sections = Storcs::Parsers::Ibm.new('ds4500','spec/data/ibm_DS4500.txt').sections
    sections.should be_a Hash
    sections.keys.length.should == 11
    sections[:arrays].should be_an Array
  end

  it "returns a list of arrays with name+raid type" do
    arrays = Storcs::Parsers::Ibm.new('ds4500','spec/data/ibm_DS4500.txt').arrays
    arrays.length.should == 15
    first = arrays.first
    first.should be_a Storcs::Device
    first.name.should == "ARRAY 1"
    first.raid.should == "5"
  end

  it "divides each array into a set of logical volumes" do
    array = Storcs::Parsers::Ibm.new('ds4500','spec/data/ibm_DS4500.txt').arrays.first
    array.should be_a Storcs::Device
    array.children.should have_exactly(17).items
    first = array.children.first
    first.should be_a Storcs::Device
    first.name.should == "array1_LUN0_app01_5G"
    first.size.should == 5368709120
    first.used.should == first.size
    array.size.should == 1316496596795
    array.used.should == 655826473713
  end
end
