require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Storcs::Parsers::Nss do

  it "parses the output of a 'iscli getpdevinfo -L'" do
    parsed = Storcs::Parsers::Nss.new("NSS", "spec/data/nss.txt")

    device = parsed.device

    device.size.should == 17165189
    device.used.should == 3230663
    device.free.should == 13934526

    device.children.size.should == 2

    pool_a = device.children.first
    pool_a.name.should == "pool-a"
    pool_a.size.should == 8582594
    pool_a.used.should == 2153775
    pool_a.free.should == 6428819
  end
end
