require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Storcs::Parsers::Netapp do

  it "parses the output of 'aggr show_space'" do
    parsed = Storcs::Parsers::Netapp.new("netapp", "spec/data/netapp.txt")

    device = parsed.device
    device.size.should == 11993243459584 # total allocated + snapshots
    device.unassigned.should == 2803719380992

    device.children.size.should == 2
    aggr_1 = device.children.last
    aggr_1.name.should == "aggr_SAS_data"
    aggr_1.size.should == 11488418308096
    aggr_1.used.should == 6963951202304
    aggr_1.free.should == 4524467105792

    aggr_1.children.size.should == 3
    vol_a = aggr_1.children.first
    vol_a.name.should == "a"
    vol_a.size.should == 4422480101376
    vol_a.used.should == 2066870439936
    vol_a.free.should == 2355609661440
  end
end
