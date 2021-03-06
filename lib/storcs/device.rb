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
      return 0 unless size.integer? && size > 0
      (100 * used.to_f / size).round(2)
    end

    def percent_free
      return 0 unless size.integer? && size > 0
      (100 * free.to_f / size).round(2)
    end
  end
end
