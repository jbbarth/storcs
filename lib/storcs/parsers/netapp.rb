module Storcs::Parsers
  class Netapp
    include Storcs::Parsers::Utils

    attr_accessor :device

    def initialize(name, file)
      @device = Storcs::Device.new(name)
      @lines = File.readlines(file)
      parse!
    end

    def parse!
      @device.children = aggregates
    end

    def aggregates
      return @aggregates if @aggregates
      @aggregates = []

      state = nil
      current_aggr = nil
      current_aggr_usable_size = 0

      @lines.each do |line|
        # Aggregate 'aggr0'
        if line =~ /^Aggregate '([^']*)'/
          name = Regexp.last_match[1]
          current_aggr = Storcs::Device.new(name)
          current_aggr.children = []
          state = :aggr
        elsif state == :aggr
          case line
          # Volume Allocated Used Guarantee
          when /^Volume.+Allocated/
            state = :volume
          # Total space 492030416KB 12922692KB 23052692KB
          when /^Total space\s+(.*)$/
            data = Regexp.last_match[1]
            alloc = parse_size(data.split(/\s+/).first)
            current_aggr.real_unassigned = current_aggr_usable_size - alloc
            current_aggr_usable_size = 0
          # Snap reserve 0KB 1406504KB 0KB
          when /^Snap reserve\s+(.*)$/
            data = Regexp.last_match[1]
            vol = Storcs::Device.new('Snapshots')
            size = parse_size(data.split(/\s+/)[1])
            vol.real_size = vol.real_used = size
            current_aggr.children << vol
            current_aggr.real_unassigned -= size
            @aggregates << current_aggr
            current_aggr = nil
          # Total space  WAFL reserve  Snap reserve  ...
          when /^\s+Total space/
            state = :aggr_total
          end
        # 573419008KB 57341880KB 0KB 516077128KB 0KB 0KB 0KB
        elsif state == :aggr_total
          usable_size = line.split(/\s+/)[4]
          current_aggr_usable_size = parse_size(usable_size)
          state = :aggr
        elsif state == :volume
          case line
          when /^\s*$/
            state = :aggr
          # vol0 492030416KB 12922692KB volume
          else
            name, alloc, used = line.split(/\s+/)
            vol = Storcs::Device.new(name)
            vol.real_size = parse_size(alloc)
            vol.real_used = parse_size(used)

            current_aggr.children << vol
          end
        end
      end

      @aggregates
    end
  end
end
