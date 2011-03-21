module Storcs
  module SummableSizes
    # Avoids defining recursively summable columns again
    # and again. Usage:
    #
    #   class Device
    #     summable_sizes :size, :used, :blah
    #     ...
    #   end
    #
    # For instance, here's the result for 'used' size:
    #
    #   def used
    #     real_used || children.inject(0) do |memo,child|
    #       memo + child.used
    #     end
    #   end
    #
    def summable_sizes(*columns)
      columns.each do |column|
        class_eval <<-EOF
          attr_accessor :real_#{column}
          def #{column}
            real_#{column} || children.inject(0) do |memo,child|
              memo + child.#{column}
            end
          end
        EOF
      end
    end
  end
end

