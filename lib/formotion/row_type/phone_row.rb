module Formotion
  module RowType
    class PhoneRow < StringRow

      def keyboardType
        UIKeyboardTypePhonePad
      end

    end
  end
end