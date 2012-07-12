module Formotion
  module RowType
    class DateRow < Character
      def update
        self.row.text_field && self.row.text_field.text = self.formatted_value
      end

      def date_value
        value = self.row.value
        if value.is_a? Numeric
          NSDate.dateWithTimeIntervalSince1970(value.to_i)
        else
          nil
        end
      end

      def formatted_value
        @formatter ||= begin
          formatter = NSDateFormatter.new

          date_style = self.row.format
          if date_style && date_style.to_s[-5..-1] != "style"
            date_style = (date_style.to_s + "_style").to_sym
          end
          formatter.dateStyle = self.row.send(:const_int_get, "NSDateFormatter", date_style || NSDateFormatterShortStyle)
          formatter
        end

        return @formatter.stringFromDate(self.date_value) if self.date_value
        self.row.value
      end

      def after_build(cell)
        self.row.text_field.inputView = self.picker
        update
      end

      def picker
        @picker ||= begin
          picker = UIDatePicker.alloc.initWithFrame(CGRectZero)
          picker.datePickerMode = UIDatePickerModeDate
          picker.hidden = false
          picker.date = self.date_value || NSDate.date

          picker.when(UIControlEventValueChanged) do
            # 1. update row's value
            self.row.value = @picker.date.timeIntervalSince1970.to_i
            # 2. update textField's value to reflect format of this.
            # unfortunately thsi also changes self.row.value to this formatte
            # version so...
            update
            # 3. reset it back to the integer.
            self.row.value = @picker.date.timeIntervalSince1970.to_i
          end

          picker
        end
      end
    end
  end
end