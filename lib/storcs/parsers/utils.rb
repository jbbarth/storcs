module Storcs
  module Parsers
    module Utils
      def parse_size(line)
        size = line.gsub(/[^a-z0-9().,]/i, '') #1,234 and 1 234 => 1234 + sanitizes some awful chars
        if size.tr(",.","").match(/(\d+)Bytes\)/)
          return $1.to_i
        end
        size.gsub!(/\(.*/,"")
        units = %w(KB MB GB TB PB)
        #let's try to guess the format :/
        size.gsub!(",","") if size.include?(",") && size.include?(".")
        size.gsub!(",","") if size.scan(",").length > 1
        size.gsub!(",",".")
        num = size.to_f
        units.each_with_index do |u,idx|
          if size.include?(u)
            num = num * 1024 ** (idx+1) 
          end
        end
        num.round
      end
    end
  end
end
