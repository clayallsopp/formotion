module Formotion
  module RowType
    ROW_TYPES = Formotion::RowType.constants(false).select { |constant_name| constant_name =~ /Row$/ }

    class << self
      def for(string_or_sym)
        type = string_or_sym

        if type.is_a?(Symbol) or type.is_a? String
          string = "#{type.to_s.downcase}_row".camelize
          if not const_defined? string
            raise Formotion::InvalidClassError, "Invalid RowType value #{string_or_sym}. Create a class called #{string}"
          end
          Formotion::RowType.const_get(string)
        else
          raise Formotion::InvalidClassError, "Attempted row type #{type.inspect} is not a valid RowType."
        end
      end
    end
  end
end