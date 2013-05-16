motion_require 'string_row'

module Formotion
  module RowType
    class StaticRow < StringRow
      def after_build(cell)
        self.row.text_field.enabled = false
        cell.selectionStyle = self.row.selection_style
      end
    end
  end
end
