module Storcs::Parsers
  class Nss
    include Storcs::Parsers::Utils

    attr_accessor :device

    def initialize(name,file)
      @device = Storcs::Device.new(name)
      @lines = File.readlines(file)
      parse!(@lines)
    end

    def parse!(content)
      @device.children = pools
    end

    def pools
      return @pools if @pools
      @pools = []

      current_allocated = nil
      @lines.each do |line|
        if line =~ /^Total (Available|Allocated) Space in "([^"]*)" \(ID: \d+\): (.* MB)/
          case $1
          when 'Allocated'
            current_allocated = parse_size($3)
          when 'Available'
            current_available = parse_size($3)
            @pools << Storcs::Device.new($2)
            @pools.last.real_size = current_allocated + current_available
            @pools.last.real_used = current_allocated
            current_allocated = nil
          end
        end
      end
      @pools
    end
  end
end
