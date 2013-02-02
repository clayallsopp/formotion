module Formotion
  module RowType
    class CurrencyRow < NumberRow

      def add_callbacks(field)
        super

        field.should_change? do |text_field, range, replacements|

          original_txt = text_field.text
          edited_txt = original_txt.stringByReplacingCharactersInRange(range, withString:replacements)
          entered_digits = edited_txt.gsub %r{\D+}, ''

          if entered_digits.length >= 9
            
            text_field.text = original_txt

          else 

            if entered_digits.empty?
              decimal_num = 0.0
            else
              decimal_num = entered_digits.to_i * (10 ** currency_scale)
              decimal_num = decimal_num.to_f
            end

            text_field.text = number_formatter.stringFromNumber decimal_num

          end

          false
        end

      end


      def row_value
        number_formatter.stringFromNumber super.to_f
      end


      def value_for_save_hash
        number_formatter.numberFromString(row.text_field.text) || 0.0
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