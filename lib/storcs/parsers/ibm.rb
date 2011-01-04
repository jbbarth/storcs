module Storcs::Parsers
  class Ibm
    include Storcs::Parsers::Utils

    attr_accessor :device

    def initialize(file)
      @device = Storcs::Device.new("")
      @lines = File.readlines(file)
      parse!(@lines)
    end

    def parse!(content)
      @device.children = arrays
    end

    def sections
      return @sections if @sections
      @sections = {}
      current_section = nil
      @lines.each do |line|
        if line.chomp.match(/^([A-Z ]{3,}).*-------$/)
          current_section = $1.downcase.to_sym
          @sections[current_section] = []
        elsif current_section
          @sections[current_section] << line
        end
      end
      @sections
    end

    def arrays
      return @arrays if @arrays
      @arrays = sections[:arrays].map do |line|
        if line.match /^   (ARRAY \d+)\s+\(RAID (\w+)\)/
          s = Storcs::Device.new($1)
          s.raid = $2
          s
        end
      end.compact
      @arrays
    end
  end
end
