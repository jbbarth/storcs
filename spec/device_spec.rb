require File.expand_path('../spec_helper',__FILE__)

describe Storcs::Device do
  before(:each) do
    @bay = Storcs::Device.new("bay1")
    @array1  = Storcs::Device.new("array1"); @array1.real_size = 10; @array1.real_used = 8
    @array2  = Storcs::Device.new("array2"); @array2.real_size = 10; @array2.real_used = 3
    @bay.children << @array1
    @bay.children << @array2
  end

  it "creates a new device" do
    @bay.should_not be_nil
    @bay.name.should == "bay1"
  end

  it "has basic (nested) methods" do
    @array1.used.should == 8
    @array1.size.should == 10
    @bay.used.should == 11
    @bay.size.should == 20
    @bay.free.should == 9
  end

  it "calculates the percent used and free" do
    @bay.percent_used.should == 55
    @bay.percent_free.should == 45
  end

  it "ensures a device with no size doesn't screw up on calculations" do
    device = Storcs::Device.new("bay")
    device.percent_used.should == 0
    device.percent_free.should == 0
  end
end
