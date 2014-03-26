motion_require 'string_row'

module Formotion
  module RowType
    class NumberRow < StringRow

      def keyboardType
        if BW::Device.ipad?
          return UIKeyboardTypeNumberPad
        end
        UIKeyboardTypeDecimalPad
      end

    end
  end
end
