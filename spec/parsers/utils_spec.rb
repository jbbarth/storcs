describe Storcs::Parsers::Utils do
  include Storcs::Parsers::Utils
  
  describe "#parse_size" do
    it "parses size units correctly" do
      to_test = {
        "577"                         => 577,
        "1 KB"                        => 1024,
        "1 MB"                        => 1024**2,
        "1 GB"                        => 1024**3,
        "1 TB"                        => 1024**4,
        "1 PB"                        => 1024**5,
        "2.501 GB"                    => 2.501*1024**3,
        "112.641 GB"                  => 112.641*1024**3
      }
      to_test.each do |k,v|
        parse_size(k).should == v.round
      end
    end

    it "interprets comas as dots inside the number" do
      to_test = {
        "37,39 GB"                    => 37.39*1024**3,
        "22,284 GB"                   => 22.284*1024**3,
        "235,079 GB"                  => 235.079*1024**3
      }
      to_test.each do |k,v|
        parse_size(k).should == v.round
      end
    end

    it "prioritize the values inside parentesis if numbers and ignores comas inside" do
      to_test = {
        "56,234 GB (143453 Bytes)"        => 143453,
        "10 000 KB (blah Bytes)"      => 10240000,
        "10 000 KB (43 242 Bytes)"    => 43242,
        "953,572 GB (1 023 890 138 112 Bytes)" => 1023890138112,
        "9,329 GB (10 016 522 240 Bytes)" => 10016522240,
        "11,293 GB (12 125 732 864 Bytes)" => 12125732864,
        "203.597 GB (218,610,794,496 Bytes)" => 218610794496,
        "5 GB (5,368,709,120 Bytes)" => 5368709120
      }
      to_test.each do |k,v|
        parse_size(k).should == v.round
      end
    end

    it "knows everything about scientific notation" do
      to_test = {
        "3.1234E+011"                 => 3.1234*10**11,
      }
      to_test.each do |k,v|
        parse_size(k).should == v.round
      end
    end
  end
end
