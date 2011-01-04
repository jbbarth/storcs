module Storcs::Parsers
  class Equalogic
    include Storcs::Parsers::Utils

    attr_accessor :device

    def initialize(name,file)
      @device = Storcs::Device.new(name)
      parse!(File.readlines(file))
    end

    def parse!(lines)
      @device.children = volumes(lines)
    end

    def volumes(lines)
      return @volumes if @volumes
      @volumes = []
      current_section = nil
      lines.each do |line|
        line.strip!
        if line.match /________ ([^_]+) ________/
          current_section = $1.downcase
        elsif %w(pools volumes).include?(current_section) && line.split[2].to_s.match(/^\d+$/)
          if current_section == "volumes" && line.match(/^(\S+)\s+(\S+)/)
            #g01-varlibnfs   50MB       0         online         read-write 2           N 
            d = Storcs::Device.new($1)
            d.real_size = parse_size($2)
            d.real_used = d.real_size
            @volumes << d
          elsif current_section == "pools" && line.match(/(\S+)$/)
            #default              true    1       10      3744.01GB  43.88GB    
            d = Storcs::Device.new("free")
            d.real_size = parse_size($1)
            d.real_used = 0
            @volumes << d
          end
        end
      end
      @volumes
    end
  end
end
