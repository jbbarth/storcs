module Storcs::Parsers
  class DfNas
    attr_accessor :device

    def initialize(name,file)
      @device = Storcs::Device.new(name)
      parse!(File.readlines(file))
    end

    def parse!(content)
      ary = content.map do |l|
        l.split(/\s+/)
      end.detect do |a|
        a[1] && a[1].match(/^\d+$/)
      end
      @device.real_size = ary[1].to_i * 1024
      @device.real_used = ary[2].to_i * 1024
    end
  end
end
