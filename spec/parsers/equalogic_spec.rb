require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Storcs::Parsers::Equalogic do
  it "parses the output of a 'show' command inside the console" do
    parsed = Storcs::Parsers::Equalogic.new('ps5000','spec/data/equalogic_PS5000XV.txt')
    bay = parsed.device
    bay.should_not be_nil
    bay.name.should == "ps5000"
    bay.size.should == 4020012968837
    bay.used.should == 3972897177600
    bay.free.should ==   47115791237
  end

  it "divides the bay into a set of logical volumes" do
    device = Storcs::Parsers::Equalogic.new('ps5000','spec/data/equalogic_PS5000XV.txt').device
    device.children.first.should be_a Storcs::Device
    device.children.should have_exactly(11).items
    first = device.children.first
    first.should be_a Storcs::Device
    first.name.should == "g01-app01"
    first.size.should == 858993459200
    first.used.should == first.size
    free = device.children.last
    free.name.should == "free"
    free.size.should == 47115791237
    free.used.should == 0
  end
end
