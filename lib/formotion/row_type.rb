module Formotion
  class RowType
    STRING=0
    EMAIL=1
    PHONE=2
    NUMBER=3
    SUBMIT=4
    SWITCH=5
    CHECK=6
    STATIC=100

    TYPES = [STRING, EMAIL, PHONE, NUMBER, SUBMIT, SWITCH, CHECK, STATIC]
    TEXT_FIELD_TYPES=[STRING, EMAIL, PHONE, NUMBER]

    class << self
      def for(string_or_sym_or_int)
        type = string_or_sym_or_int

        if type.is_a?(Symbol) or type.is_a? String
          string = type.to_s.upcase
          if not const_defined? string
            raise Formotion::InvalidClassError, "Invalid RowType value #{string_or_sym}"
          end
          Formotion::RowType.const_get(string)
        elsif type.is_a? Integer and TYPES.member? type
          TYPES[type]
        else
          raise Formotion::InvalidClassError, "Attempted row type #{type.inspect} is not a valid RowType."
        end
      end
    end
  end
end