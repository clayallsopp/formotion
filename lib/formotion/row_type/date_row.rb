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
          formatter.timeStyle = NSDateFormatterNoStyle
          formatter
        end
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
            if self.row.picker_mode == :countdown
              self.row.value = @picker.countDownDuration
            else
              self.row.value = @picker.date.timeIntervalSince1970.to_i
            end
            update
          end

          picker
        end
      end

      def picker_mode
        case self.row.picker_mode
        when :time
          UIDatePickerModeTime
        when :date_time
          UIDatePickerModeDateAndTime
        when :countdown
          UIDatePickerModeCountDownTimer
        else
          UIDatePickerModeDate
        end
      end

      def formatted_value
        if self.date_value
          return case self.row.picker_mode
            when :time
              old_date_style = formatter.dateStyle
              formatter.dateStyle = NSDateFormatterNoStyle
              formatter.timeStyle = NSDateFormatterShortStyle
              formatted = formatter.stringFromDate(self.date_value)
              formatter.dateStyle = old_date_style
              formatter.timeStyle = NSDateFormatterNoStyle
              formatted
            when :date_time
              old_date_style = formatter.dateStyle
              formatter.dateStyle = NSDateFormatterShortStyle
              formatter.timeStyle = NSDateFormatterShortStyle
              formatted = formatter.stringFromDate(self.date_value)
              formatter.dateStyle = old_date_style
              formatter.timeStyle = NSDateFormatterNoStyle
              formatted
            when :countdown
              time = self.row.value
              date = NSDate.dateWithTimeIntervalSinceReferenceDate(time)
              old_date_style = formatter.dateStyle
              old_time_zone = formatter.timeZone

              formatter.dateFormat = "HH:mm"
              formatter.timeZone = NSTimeZone.timeZoneForSecondsFromGMT(0)
              formatted = formatter.stringFromDate(date)

              formatter.dateStyle = old_date_style
              formatter.timeZone = old_time_zone
              formatter.dateFormat = nil
              formatted
            else
              formatter.stringFromDate(self.date_value)
            end
        end
        self.row.value
      end

      # Used when row.value changes
      def update_text_field(new_value)
        self.row.text_field.text = self.formatted_value
      end
    end
  end
end
