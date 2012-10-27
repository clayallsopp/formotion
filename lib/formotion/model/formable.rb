module Formotion
  module Formable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      INHERITABLE_ATTRIBUTES = [:form_properties, :form_title].each do |prop|
        attr_accessor prop
      end

      # Does NOT get called when KVO occurs.
      # (KVO uses isa swizzling and not proper subclassing)
      def inherited(subclass)
        INHERITABLE_ATTRIBUTES.each do |inheritable_attribute|
          instance_var = "@#{inheritable_attribute}"
          subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
        end
      end

      def form_properties
        @form_properties ||= self.superclass.form_properties if is_kvo_subclass?
        @form_properties ||= []
      end

      # Relates a property to a RowType.
      # @param property is the name of the attribute to KVO
      # @param row_type is the Formotion::RowType to use for that attribute
      # @param options are the extra options for this model. Keys can include
      #   any usual Formotion::Row keys to override, plus :transform, which is
      #   a single-argument lambda for transforming the row's string value before
      #   it's synced to your model.
      # EX
      # form_property :my_title => :string
      # form_property :my_date => :date, :transform => lambda { |value| some_function(date) }
      def form_property(property, row_type, options = {})
        self.form_properties << { property: property, row_type: row_type}.merge(options)
      end

      # Sets the top bar title for this model
      # EX
      # form_title "Some Settings"
      def form_title(title = -1)
        @form_title ||= self.superclass.form_title if is_kvo_subclass?
        @form_title = title if title != -1
        @form_title
      end

      private
      # Terrible, terrible hack.
      def is_kvo_subclass?
        self.to_s =~ /^NSKVONotifying_/
      end
    end

    # Creates a Formotion::Form out of the model
    def to_form
      rows = self.class.form_properties.collect { |options|
        {
          title: options[:property].capitalize,
          key: options[:property],
          type: options[:row_type],
          value: self.send(options[:property])
        }.merge(options)
      }
      form_hash = {
        title: self.class.form_title || self.class.to_s.capitalize,
        sections: [{
          rows: rows
        }]
      }

      form = Formotion::Form.new(form_hash)
      form.on_submit do
        self.on_submit
      end

      # Use the :transform lambdas passed in form_property
      form.sections.first.rows.each_with_index { |row, index|
        row.instance_variable_set("@formable_options", self.class.form_properties[index])
        if self.class.form_properties[index][:transform]
          row.class.send(:alias_method, :old_value_setter, :value=)
          row.instance_eval do
            def value=(value)
              old_value_setter(@formable_options[:transform].call(value))
            end
          end
        end
      }

      form
    end

    # what happens when the form is submitted?
    def on_submit
      p "need to implement on_submit in your Formable model #{self.class.to_s}"
    end
  end
end