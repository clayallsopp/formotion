module Formotion
  module RowType
    class StaticRow < StringRow
      def after_build(cell)
        self.row.text_field.enabled = false
      end
    end
  end
end