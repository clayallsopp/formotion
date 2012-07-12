module Formotion
  module RowType
    class EmailRow < StringRow

      def keyboardType
        UIKeyboardTypeEmailAddress
      end

    end
  end
end