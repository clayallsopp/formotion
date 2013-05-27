module Formotion
  module RowType
    module MultiChoiceRow

    def build_cell(cell)
      field = super(cell)
      field.clearButtonMode = UITextFieldViewModeNever
      field.swizzle(:caretRectForPosition) do
        def caretRectForPosition(position)
          CGRectZero
        end
      end
      field
    end

    def add_callbacks(field)
      super
      field.should_change? do |text_field|
        false
      end
    end

    end
  end
end