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
        if line =~ /^Total (Available|Allocated) Space in "([^"]*)" \(ID: \d+\): (.*) MB/
          size = $3.tr(',', '').to_i * 1024 * 1024
          case $1
          when 'Allocated'
            current_allocated = size
          when 'Available'
            current_available = size
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
