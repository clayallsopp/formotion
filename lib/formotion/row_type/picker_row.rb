# currently supports only one component

module Formotion
  module RowType
    class PickerRow < StringRow
      include RowType::ItemsMapper

      def after_build(cell)
        self.row.text_field.inputView = self.picker
        self.row.text_field.text = name_for_value(row.value).to_s
      end

      def picker
        @picker ||= begin
          picker = UIPickerView.alloc.initWithFrame(CGRectZero)
          picker.showsSelectionIndicator = true
          picker.hidden = false
          picker.dataSource = self
          picker.delegate = self

          if self.row.value
            picker_row = name_index_of_value(row.value)
            if picker_row != nil
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
        self.items.size
      end

      def pickerView(pickerView, titleForRow:index, forComponent:component)
        self.item_names[index]
      end

      def pickerView(pickerView, didSelectRow:index, inComponent:component)
        update_text_field(value_for_name_index(index))
      end

      def on_change(text_field)
        break_with_semaphore do
          row.value = value_for_name(text_field.text)
        end
      end

      def update_text_field(new_value)
        self.row.text_field.text = name_for_value(new_value)
      end

      def row_value
        name_for_value(row.value)
      end
    end
  end
end