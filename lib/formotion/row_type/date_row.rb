module Formotion
  module RowType
    class DateRow < Character
      attr_accessor :edited

      # overwrite Character on_change method
      def on_change(text_field)
      end

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

      def formatter
        @formatter ||= begin
          formatter = NSDateFormatter.new

          date_style = self.row.format
          if date_style && date_style.to_s[-5..-1] != "style"
            date_style = (date_style.to_s + "_style").to_sym
          end
          formatter.dateStyle = self.row.send(:const_int_get, "NSDateFormatter", date_style || NSDateFormatterShortStyle)
          formatter
        end
      end

      def formatted_value
        return formatter.stringFromDate(self.date_value) if self.date_value
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
            self.row.value = @picker.date.timeIntervalSince1970
            update
          end

          picker
        end
      end
    end
  end
end