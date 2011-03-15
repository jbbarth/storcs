module Storcs
  class Device
    extend SummableSizes

    attr_accessor :name, :children, :raid
    summable_sizes :size, :used, :unassigned

    def initialize(name)
      @name = name
      @children = []
    end

    def free
      size - used
    end

    def percent_used
      (100 * used / size).round
    end

    def percent_free
      (100 * free / size).round
    end
  end
end
