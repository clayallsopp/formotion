module Formation
  class RowCellBuilder
    class << self
      def make_cell(row)
        cell, field = nil
        #case self.type
        #when RowType::STRING
        #when RowType::PHONE
        #else
        cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:row.reuse_identifier)
        #end

        # TODO: update these on scrolls.
        cell.accessoryType = UITableViewCellAccessoryNone
        cell.textLabel.text = row.title
        cell.detailTextLabel.text = row.subtitle

        if row.switchable?
          make_switch_cell(row, cell)
        elsif row.checkable?
          make_check_cell(row, cell)
        elsif row.editable?
          field = make_text_field(row, cell)
        end
        [cell, field]
      end

      def make_check_cell(row, cell)
        cell.accessoryType = row.value ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
      end

      def make_switch_cell(row, cell)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        switchView = UISwitch.alloc.initWithFrame(CGRectZero)
        cell.accessoryView = switchView
        switchView.setOn(row.value || false, animated:false)
        switchView.when(UIControlEventValueChanged) do
          row.value = switchView.isOn
        end
      end

      def make_text_field(row, cell)
        field = UITextField.alloc.initWithFrame(CGRectMake(0, 0, 200, 44))
        field.clearButtonMode = UITextFieldViewModeWhileEditing
        field.setFrame(CGRectMake(100, 
                                      ((44 - field.frame.size.height) / 2).round, 
                                      field.frame.size.width,
                                      field.frame.size.height))
        field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter

        case row.type
        when RowType::EMAIL
          field.keyboardType = UIKeyboardTypeEmailAddress
        when RowType::PHONE
          field.keyboardType = UIKeyboardTypePhonePad
        when RowType::NUMBER
          field.keyboardType = UIKeyboardTypeDecimalPad
        else
          field.keyboardType = UIKeyboardTypeDefault
        end
        
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
            if row.next_row && row.next_row.field
              row.next_row.field.becomeFirstResponder
            else
            text_field.resignFirstResponder
            end
            true
          end
        end

        field.on_begin do |text_field|
          if row.on_begin_callback
            row.on_begin_callback.call
          end
        end

        field.should_begin? do |text_field|
          row.section.form.active_row = row
          true
        end

        field.placeholder = row.placeholder
        field.text = row.value
        field.on_change do |text_field|
          row.value = text_field.text
        end
        cell.addSubview(field)
        field
      end
    end
  end
end