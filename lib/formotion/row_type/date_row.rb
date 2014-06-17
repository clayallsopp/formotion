motion_require 'string_row'
motion_require 'multi_choice_row'

module Formotion
  module RowType
    class DateRow < StringRow
      include RowType::MultiChoiceRow

      # overwrite Character on_change method
      def on_change(text_field)
      end

      def update
        self.row.text_field && self.row.text_field.text = self.formatted_value
      end

      def date_value
        date_from_numeric(self.row.value)
      end

      def minimum_date
        date_from_numeric(self.row.minimum_date)
      end

      def maximum_date
        date_from_numeric(self.row.maximum_date)
      end

      def formatter
        @formatter ||= begin
          formatter = NSDateFormatter.new

          date_style = self.row.format

          if date_style == :string
            formatter.dateFormat = self.row.date_format
          else
            if date_style && date_style.to_s[-5..-1] != "style"
              date_style = (date_style.to_s + "_style").to_sym
            end

            formatter.dateStyle = self.row.send(:const_int_get, "NSDateFormatter", date_style || NSDateFormatterShortStyle)
            formatter.timeStyle = NSDateFormatterNoStyle
          end

          formatter
        end
      end

      def after_build(cell)
        self.row.text_field.inputView = self.picker
        # work around an iOS7 bug: http://bit.ly/KcwKSv
        if row.picker_mode == :countdown
          self.picker.setDate(self.picker.date, animated:true)
          picker.countDownDuration = self.row.value.to_f
        end
        
        #ensure the UIDatePicker gets updated if we update the row value 
        observe(self.row, "value") do |old_value, new_value|
          self.picker.setDate(date_from_numeric(new_value), animated:true)
        end

        update
      end

      def picker
        @picker ||= begin
          picker = UIDatePicker.alloc.initWithFrame(CGRectZero)
          picker.datePickerMode = self.picker_mode
          picker.hidden = false
          picker.date = self.date_value || Time.now
          picker.countDownDuration = self.row.value if row.picker_mode == :countdown
          picker.minuteInterval = self.row.minute_interval if self.row.minute_interval
          picker.minimumDate = minimum_date if self.row.minimum_date
          picker.maximumDate = maximum_date if self.row.maximum_date

          picker.when(UIControlEventValueChanged) do
            if self.row.picker_mode == :countdown
              self.row.value = @picker.countDownDuration
            else
              self.row.value = Time.at(@picker.date).to_i
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

    private

      def date_from_numeric(value)
        if value.is_a? Numeric
          Time.at value
        elsif value.is_a? NSDate
          value
        else
          nil
        end
      end
    end
  end
end
