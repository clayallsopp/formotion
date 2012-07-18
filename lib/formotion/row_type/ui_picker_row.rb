# currently supports only one component

module Formotion
  module RowType
    class UiPickerRow < Character
      

      def after_build(cell)
        row.text_field.inputView = self.ui_picker
      end

      def ui_picker
        @ui_picker ||= begin
          ui_picker = UIPickerView.alloc.initWithFrame(CGRectZero)
          ui_picker.showsSelectionIndicator = true
          ui_picker.hidden = false
          ui_picker.dataSource = self
          ui_picker.delegate = self

          if(row.value)
            picker_row = row.items.index(row.value)
            ui_picker.selectRow(picker_row, inComponent:0, animated:false)
          end

          ui_picker
        end
      end

      def numberOfComponentsInPickerView(pickerView)
        1
      end

      def pickerView(pickerView, numberOfRowsInComponent:component)
        row.items.size
      end

      def pickerView(pickerView, titleForRow:index, forComponent:component)
        row.items[index]
      end

      def pickerView(pickerView, didSelectRow:index, inComponent:component)
        update_row(row.items[index])
      end

      def update_row(value)
        row.text_field && row.text_field.text = value
      end

    end
  end
end