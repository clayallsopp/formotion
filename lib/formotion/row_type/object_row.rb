motion_require 'string_row'

module Formotion
  module RowType
    class ObjectRow < StringRow

      def build_cell(cell)
        cell.selectionStyle = self.row.selection_style || UITableViewCellSelectionStyleBlue
        field = UITextField.alloc.initWithFrame(CGRectZero)
        field.tag = TEXT_FIELD_TAG

        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            update_text_field(new_value)
          end
        end

        field.clearButtonMode = UITextFieldViewModeWhileEditing
        field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
        field.textAlignment = row.text_alignment || NSTextAlignmentRight

        field.keyboardType = keyboardType

        field.secureTextEntry = true if row.secure?
        field.returnKeyType = row.return_key || UIReturnKeyNext
        field.autocapitalizationType = row.auto_capitalization if row.auto_capitalization
        field.autocorrectionType = row.auto_correction if row.auto_correction
        field.clearButtonMode = row.clear_button || UITextFieldViewModeWhileEditing
        field.enabled = row.editable?
        field.inputAccessoryView = input_accessory_view(row.input_accessory) if row.input_accessory

        add_callbacks(field)

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            formotion_field = self.viewWithTag(TEXT_FIELD_TAG)
            formotion_field.sizeToFit

            field_frame = formotion_field.frame
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + Formotion::RowType::Base.field_buffer
            field_frame.origin.y = ((self.frame.size.height - field_frame.size.height) / 2.0).round
            field_frame.size.width = self.frame.size.width - field_frame.origin.x - Formotion::RowType::Base.field_buffer
            formotion_field.frame = field_frame
          end
        end

        field.font = BW::Font.new(row.font) if row.font
        field.placeholder = row.placeholder
        field.text = row_value.to_s
        cell.addSubview(field)
        field

      end

      # Used when row.value changes
      def update_text_field(new_value)
        self.row.text_field.text = row_value.to_s
      end

      # overriden in subclasses
      def row_value
        row.value
      end

    end
  end
end
