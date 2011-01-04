module Storcs
  module Formatter
    def pretty_size(size=nil)
      size ||= self.size
      units = %w(bytes Kb Mb Gb Tb Pb)
      i = 0
      while size >=1024 && units[i+1]
        size /= 1024.0
        i += 1
      end
      "#{"%.1f" % size}#{units[i]}"
    end
  end
end
