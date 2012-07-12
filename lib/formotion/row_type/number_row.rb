module Formotion
  module RowType
    class NumberRow < StringRow

      def keyboardType
        UIKeyboardTypeDecimalPad
      end

    end
  end
end