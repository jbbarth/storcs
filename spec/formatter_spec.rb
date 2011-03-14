require File.expand_path('../spec_helper',__FILE__)

describe Storcs::Formatter do
  include Storcs::Formatter
  it "formats sizes in bytes" do
    { 1 => "1.0bytes",
      1024 => "1.0Kb",
      12345 => "12.1Kb",
      825388561334 => "768.7Gb",
      12285713148014 => "11.2Tb"
    }.each do |raw,formatted|
      pretty_size(raw).should == formatted
    end
  end
end
