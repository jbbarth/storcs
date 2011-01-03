module Storcs
  class Device
    attr_accessor :name, :children, :real_used, :real_size

    def initialize(name)
      @name = name
      @children = []
      @real_used = nil
      @real_size = nil
    end

    def size
      real_size || children.inject(0) do |memo,child|
        memo + child.size
      end
    end

    def used
      real_used || children.inject(0) do |memo,child|
        memo + child.used
      end
    end

    def free
      size - used
    end
  end
end
