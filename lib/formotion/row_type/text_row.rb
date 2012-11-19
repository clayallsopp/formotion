module Formotion
  module RowType
    class TextRow < Base
      include BW::KVO

      TEXT_VIEW_TAG=1000

      attr_accessor :field

      def build_cell(cell)

        @field = UITextView.alloc.initWithFrame(CGRectZero)
        field.backgroundColor = UIColor.clearColor
        field.editable = true
        field.tag = TEXT_VIEW_TAG

        field.text = row.value

        field.returnKeyType = row.return_key || UIReturnKeyDefault
        field.autocapitalizationType = row.auto_capitalization if row.auto_capitalization
        field.autocorrectionType = row.auto_correction if row.auto_correction
        field.placeholder = row.placeholder

        field.on_begin do |text_field|
          row.on_begin_callback && row.on_begin_callback.call
          @tap_gesture.enabled = true
        end

        field.should_begin? do |text_field|
          row.section.form.active_row = row
          true
        end

        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            field.text = row.value
          end
        end
        field.on_change do |text_field|
          break_with_semaphore do
            row.value = text_field.text
          end
        end

        field.on_end do |text_field|
          @tap_gesture.enabled = false
        end

        @tap_gesture = UITapGestureRecognizer.alloc.initWithTarget self, action:'dismissKeyboard'
        @tap_gesture.enabled = false
        cell.addGestureRecognizer @tap_gesture

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            formotion_field = self.viewWithTag(TEXT_VIEW_TAG)
            formotion_field.sizeToFit

            field_frame = formotion_field.frame
            field_frame.origin.y = 10
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + Formotion::RowType::Base.field_buffer
            field_frame.size.width  = self.frame.size.width - field_frame.origin.x - Formotion::RowType::Base.field_buffer
            field_frame.size.height = self.frame.size.height - Formotion::RowType::Base.field_buffer
            formotion_field.frame = field_frame
          end
        end

        cell.addSubview(field)
        field
      end

      def on_select(tableView, tableViewDelegate)
        field.becomeFirstResponder
      end

      def dismissKeyboard
        field.resignFirstResponder
      end

    end
  end
end