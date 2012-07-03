module Formotion
  module RowType
    class Character < Base

      # The new UITextField in a UITableViewCell
      # will be assigned this tag, if applicable.
      TEXT_FIELD_TAG=1000

      def keyboardType
        UIKeyboardTypeDefault
      end

      # Configures the cell to have a new UITextField
      # which is used to enter data. Consists of
      # 1) setting up that field with the appropriate properties
      # specified by `row` 2) configures the callbacks on the field
      # to call any callbacks `row` listens for.
      # Also does the layoutSubviews swizzle trick
      # to size the UITextField so it won't bump into the titleLabel.
      def build_cell(cell)
        field = UITextField.alloc.initWithFrame(CGRectZero)
        field.tag = TEXT_FIELD_TAG

        field.placeholder = row.placeholder
        field.text = row.value.to_s

        field.clearButtonMode = UITextFieldViewModeWhileEditing
        field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
        field.textAlignment = UITextAlignmentRight

        field.keyboardType = keyboardType

        field.secureTextEntry = true if row.secure?
        field.returnKeyType = row.return_key || UIReturnKeyNext
        field.autocapitalizationType = row.auto_capitalization if row.auto_capitalization
        field.autocorrectionType = row.auto_correction if row.auto_correction
        field.clearButtonMode = row.clear_button || UITextFieldViewModeWhileEditing

        if row.on_enter_callback
          field.should_return? do |text_field|
            if row.on_enter_callback.arity == 0
              row.on_enter_callback.call
            elsif row.on_enter_callback.arity == 1
              row.on_enter_callback.call(row)
            end
            false
          end
        elsif field.returnKeyType == UIReturnKeyDone
          field.should_return? do |text_field|
            text_field.resignFirstResponder
            false
          end
        else
          field.should_return? do |text_field|
            if row.next_row && row.next_row.text_field
              row.next_row.text_field.becomeFirstResponder
            else
              text_field.resignFirstResponder
            end
            true
          end
        end

        field.on_begin do |text_field|
          row.on_begin_callback && row.on_begin_callback.call
        end

        field.should_begin? do |text_field|
          row.section.form.active_row = row
          true
        end

        field.on_change do |text_field|
          row.value = text_field.text
        end

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            formotion_field = self.viewWithTag(TEXT_FIELD_TAG)
            formotion_field.sizeToFit

            field_frame = formotion_field.frame
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + 20
            field_frame.origin.y = ((self.frame.size.height - field_frame.size.height) / 2.0).round
            field_frame.size.width = self.frame.size.width - field_frame.origin.x - 20
            formotion_field.frame = field_frame
          end
        end

        cell.addSubview(field)
        field

      end

      def on_select(tableView, tableViewDelegate)
        row.text_field.becomeFirstResponder
      end

    end
  end
end