module Formotion
  module RowType
    class CurrencyRow < NumberRow
      def on_change(text_field)
        break_with_semaphore do
          edited_text = text_field.text
          entered_digits = edited_text.gsub %r{\D+}, ''
          decimal_num = 0.0

          if !entered_digits.empty?
            decimal_num = entered_digits.to_i * (10 ** currency_scale.to_i)
            decimal_num = decimal_num.to_f
          end

          row.value = decimal_num
          text_field.text = row_value
        end
      end

      def row_value
        number_formatter.stringFromNumber super.to_f
      end

      def value_for_save_hash
        number_formatter.numberFromString(row_value)
      end

      private
      def number_formatter
        @number_formatter ||= begin
          formatter = NSNumberFormatter.alloc.init
          formatter.numberStyle = NSNumberFormatterCurrencyStyle
          formatter.locale = NSLocale.currentLocale
          formatter
        end
      end

      def currency_scale
        @currency_scale ||= number_formatter.maximumFractionDigits * -1
      end
    end
  end
end