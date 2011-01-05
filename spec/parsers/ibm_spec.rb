require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Storcs::Parsers::Ibm do
  models = {"DS4500" => { :num_arrays => 15, :num_sections => 11, :bay_size => 12285713148014,
                          :bay_used => 11460324586680, :bay_free => 825388561334, :bay_unassigned => 731389980835,
                          :first_array_name => "ARRAY 1", :first_array_raid => "5", :first_array_ld_num => 17,
                          :ld_name => "array1_LUN0_app01_5G", :ld_size => 5368709120,
                          :array_size => 1316496596795, :array_used => 655826473713 },
            "DS3400" => { :num_arrays => 1, :num_sections => 9,
                          :bay_size => 2395702692938, :bay_used => 2395702692938, :bay_free => 0,
                          :first_array_name => "ARRAY 1", :first_array_raid => "5", :first_array_ld_num => 2,
                          :ld_name => "SAN01_LUN1", :ld_size => 1099511627776,
                          :array_size => 2395702692938, :array_used => 2395702692938 }
            }

  models.keys.each do |model|

    context "for a #{model}" do
      before(:each) do
        @parsed = Storcs::Parsers::Ibm.new(model,"spec/data/ibm_#{model}.txt")
        @expected = models[model]
      end
 
      it "parses the output of a 'SMcli X.X.X.X 'show storagesubsystem profile;' for a #{model}" do
        bay = @parsed.device
        bay.should_not be_nil
        bay.name.should == model
        bay.children.should have_exactly(@expected[:num_arrays]).items
        bay.size.should == @expected[:bay_size]
        bay.used.should == @expected[:bay_used]
        bay.free.should == @expected[:bay_free]
        bay.unassigned.should == @expected[:bay_unassigned]
      end

      it "divides a profile file into small sections" do
        sections = @parsed.sections
        sections.should be_a Hash
        sections.keys.length.should == @expected[:num_sections]
        sections[:arrays].should be_an Array
      end

      it "returns a list of arrays with name+raid type" do
        first = @parsed.arrays.first
        first.should be_a Storcs::Device
        first.name.should == @expected[:first_array_name]
        first.raid.should == @expected[:first_array_raid]
      end

      it "divides each array into a set of logical volumes" do
        array = @parsed.arrays.first
        array.should be_a Storcs::Device
        array.children.should have_exactly(@expected[:first_array_ld_num]).items
        first = array.children.first
        first.should be_a Storcs::Device
        first.name.should == @expected[:ld_name]
        first.size.should == @expected[:ld_size]
        first.used.should == first.size
        array.size.should == @expected[:array_size]
        array.used.should == @expected[:array_used]
      end
    end

  end
end
