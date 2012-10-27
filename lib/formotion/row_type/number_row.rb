module Formotion
  module RowType
    class NumberRow < StringRow

      def keyboardType
        if Device.ipad?
          return UIKeyboardTypeNumberPad
        end
        UIKeyboardTypeDecimalPad
      end

    end
  end
end