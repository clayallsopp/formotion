# currently supports only one component
motion_require 'string_row'
motion_require 'multi_choice_row'

module Formotion
  module RowType
    class PickerRow < StringRow
      include RowType::ItemsMapper
      include RowType::MultiChoiceRow

      def input_accessory_view(input_accessory)
        case input_accessory
        when :done
          @input_accessory ||= begin
            tool_bar = UIToolbar.alloc.initWithFrame([[0, 0], [0, 44]])
            tool_bar.autoresizingMask = UIViewAutoresizingFlexibleWidth
            tool_bar.translucent = true

            left_space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
                UIBarButtonSystemItemFlexibleSpace,
                target: nil,
                action: nil)

            done_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
                UIBarButtonSystemItemDone,
                target: self,
                action: :done_editing)

            tool_bar.items = [left_space, done_button]

            tool_bar
          end
        else
          nil
        end
      end

      # Callback for "Done" button in input_accessory_view
      def done_editing
        self.row.text_field.endEditing(true)
      end

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

          picker
        end

        select_picker_value(row.value) if self.row.value

        @picker
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
        select_picker_value(new_value)
      end

      def select_picker_value(new_value)
        picker_row = name_index_of_value(new_value)
        if picker_row != nil
          @picker.selectRow(picker_row, inComponent:0, animated:false)
        else
          warn "Picker item '#{row.value}' not found in #{row.items.inspect} for '#{row.key}'"
        end
      end

      def row_value
        name_for_value(row.value)
      end
    end
  end
end