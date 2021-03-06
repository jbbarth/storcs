module Storcs::Parsers
  class Ibm
    include Storcs::Parsers::Utils

    attr_accessor :device

    def initialize(name,file)
      @device = Storcs::Device.new(name)
      @lines = File.readlines(file)
      parse!(@lines)
    end

    def parse!(content)
      @device.children = arrays
      @device.real_unassigned = unassigned
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
      @arrays = []
      current_array = nil
      logical_drive_list = false
      sections[:arrays].map do |line|
        if line.match /^   (ARRAY \d+)\s+\(RAID (\w+)\)/
          current_array = Storcs::Device.new($1)
          current_array.raid = $2
          @arrays << current_array
        elsif line.match /^\s{8,}LOGICAL DRIVE NAME/
          logical_drive_list = true
        elsif line.match /^\s*$/
          logical_drive_list = false
        elsif current_array && logical_drive_list
          line.gsub!(/Free Capacity/,"free")
          name, raw_size = line.strip.scan(/(\S+)\s+(.+)/).first
          ld = Storcs::Device.new(name)
          ld.real_size = parse_size(raw_size)
          ld.real_used = (name == "free" ? 0 : ld.real_size)
          current_array.children << ld
        end
      end.compact
      @arrays
    end

    def unassigned
      return @unassigned if @unassigned
      @unassigned = 0
      in_unassigned = false
      sections[:drives].map do |line|
        if line.match /Unassigned/
          in_unassigned = true
        elsif line.match /^\s*$/
          in_unassigned = false
        elsif in_unassigned && line.match(/Usable capacity:\s+(.+)$/)
          @unassigned += parse_size($1)
        end
      end.compact
      @unassigned
    end
  end
end
