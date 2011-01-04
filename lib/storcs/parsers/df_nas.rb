module Storcs::Parsers
  class DfNas
    attr_accessor :device

    def initialize(file)
      parse!(File.readlines(file))
    end

    def parse!(content)
      ary = content.map do |l|
        l.split(/\s+/)
      end.detect do |a|
        a[1] && a[1].match(/^\d+$/)
      end
      @device = Storcs::Device.new("")
      @device.real_size = ary[1].to_i
      @device.real_used = ary[2].to_i
    end
  end
end
