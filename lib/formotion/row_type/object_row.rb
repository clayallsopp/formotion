motion_require 'string_row'

module Formotion
  module RowType
    class ObjectRow < StringRow

      def build_cell(cell)
        super.tap do |field|
        
          # "remove" the setText swizzle
          if UIDevice.currentDevice.systemVersion >= "6.0" and field.respond_to?("old_setText")
            unswizzle = Proc.new do
              def setText(text)
                old_setText(text)
              end
            end
            field.instance_eval unswizzle
          end

        end
      end

      # overriden in subclasses
      def row_value
        row.value
      end

    end
  end
end
