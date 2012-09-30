module Formotion
  class InvalidClassError < StandardError; end
  class InvalidSectionError < StandardError; end
  class NoRowTypeError < StandardError; end

  class Conditions
    class << self
      def assert_nil_or_boolean(obj)
        if not (obj.nil? or obj.is_a? TrueClass or obj.is_a? FalseClass)
          raise Formotion::InvalidClassError, "#{obj.inspect} should be nil, true, or false, but is #{obj.class.to_s}"
        end
      end

      def assert_class(obj, klass)
        if not obj.is_a? klass
          raise Formotion::InvalidClassError, "#{obj.inspect} of class #{obj.class.to_s} is not of class #{klass.to_s}"
        end
      end
    end
  end
end