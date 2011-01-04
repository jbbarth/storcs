require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Storcs::Parsers::DfNas do
  it "parses a df -m output" do
    parsed = Storcs::Parsers::DfNas.new('spec/data/df_nas.txt')
    parsed.device.should_not be_nil
    parsed.device.used.should == 598024
    parsed.device.size.should == 795481
    parsed.device.free.should == 197457
  end
end
