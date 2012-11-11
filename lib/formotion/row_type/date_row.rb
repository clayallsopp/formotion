module Formotion
  module RowType
    class DateRow < StringRow
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
          picker.datePickerMode = self.picker_mode
          picker.hidden = false
          picker.date = self.date_value || NSDate.date

          picker.when(UIControlEventValueChanged) do
            self.row.value = format_picker_value(@picker)
            update
          end

          picker
        end
      end

      def picker_mode
        case self.row.picker_mode
          when :time then UIDatePickerModeTime
          when :date then UIDatePickerModeDate
          when :datetime then UIDatePickerModeDateAndTime
          when :countdown then UIDatePickerModeCountDownTimer
          else UIDatePickerModeDate
        end
      end

      def format_picker_value(picker)
        case self.row.picker_mode
          when :time then picker.date.strftime("%I:%M %p")
          when :countdown then picker.date.strftime("%R")
          else picker.date.timeIntervalSince1970.to_i
        end
      end

      # Used when row.value changes
      def update_text_field(new_value)
        self.row.text_field.text = self.formatted_value
      end
    end
  end
end
