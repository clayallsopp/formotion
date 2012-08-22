# currently supports only one component

module Formotion
  module RowType
    class PickerRow < StringRow

      def after_build(cell)
        self.row.text_field.inputView = self.picker
      end

      def picker
        @picker ||= begin
          picker = UIPickerView.alloc.initWithFrame(CGRectZero)
          picker.showsSelectionIndicator = true
          picker.hidden = false
          picker.dataSource = self
          picker.delegate = self

          if self.row.value
            picker_row = self.row.items.index(row.value)
            if picker_row
              picker.selectRow(picker_row, inComponent:0, animated:false)
            else
              warn "Picker item '#{row.value}' not found in #{row.items.inspect} for '#{row.key}'"
            end
          end

          picker
        end
      end

      def numberOfComponentsInPickerView(pickerView)
        1
      end

      def pickerView(pickerView, numberOfRowsInComponent:component)
        self.row.items.size
      end

      def pickerView(pickerView, titleForRow:index, forComponent:component)
        self.row.items[index]
      end

      def pickerView(pickerView, didSelectRow:index, inComponent:component)
        update_row(self.row.items[index])
      end

      def update_row(value)
        self.row.text_field && self.row.text_field.text = value
      end

    end
  end
end