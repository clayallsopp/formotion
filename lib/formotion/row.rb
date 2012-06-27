module Formotion
  class Row < Formotion::Base
    PROPERTIES = [
      # @form.render will contain row's value as the value for this key.
      :key,
      # the user's (or configured) value for this row.
      :value,
      # set as cell.titleLabel.text
      :title,
      # set as cell.detailLabel.text
      :subtitle,
      # configures the type of input this is (string, phone, switch, etc)
      # either Formotion::RowType or a string/symbol representation of one
      # see row_type.rb
      :type,

      # The following apply only to text-input fields

      # placeholder text
      :placeholder,
      # whether or not the entry field is secure (like a password)
      :secure,
      # given by a UIReturnKey___ integer, string, or symbol
      # EX :default, :google
      :return_key,
      # given by a  UITextAutocorrectionType___ integer, string, or symbol
      # EX :yes, :no, :default
      :auto_correction,
      # given by a UITextAutocapitalizationType___ integer, string, or symbol
      # EX :none, :words
      :auto_capitalization,
      # field.clearButtonMode; given by a UITextFieldViewMode__ integer, string, symbol
      # EX :never, :while_editing
      # DEFAULT is nil, which is used as :while_editing
      :clear_button]
    PROPERTIES.each {|prop|
      attr_accessor prop
    }
    BOOLEAN_PROPERTIES = [:secure]
    SERIALIZE_PROPERTIES = PROPERTIES

    # Reference to the row's section
    attr_accessor :section

    # Index of the row in the section
    attr_accessor :index

    # The reuse-identifier used in UITableViews
    # By default is a stringification of section.index and row.index,
    # thus is unique per row (bad for memory, to fix later.)
    attr_accessor :reuse_identifier

    # The following apply only to text-input fields

    # reference to the row's UITextField.
    attr_reader :text_field

    # callback for what happens when the user
    # hits the enter key while editing #text_field
    attr_accessor :on_enter_callback
    # callback for what happens when the user
    # starts editing #text_field.
    attr_accessor :on_begin_callback

    # row type object
    attr_accessor :object

    def initialize(params = {})
      super

      BOOLEAN_PROPERTIES.each {|prop|
        Formotion::Conditions.assert_nil_or_boolean(self.send(prop))
      }
    end

    # Makes all ::BOOLEAN_PROPERTIES queriable with an appended ?
    # these should be done with alias_method but there's currently a bug
    # in RM which messes up attr_accessors with alias_method
    # EX
    # row.secure?
    # => true
    # row.checkable?
    # => nil
    def method_missing(method, *args, &block)
      boolean_method = (method.to_s[0..-2]).to_sym
      if BOOLEAN_PROPERTIES.member? boolean_method
        return self.send(boolean_method)
      end
      super
    end

    #########################
    # pseudo-properties

    def index_path
      NSIndexPath.indexPathForRow(self.index, inSection:self.section.index)
    end

    def form
      self.section.form
    end

    def reuse_identifier
      @reuse_identifier || "SECTION_#{self.section.index}_ROW_#{self.index}"
    end

    def next_row
      # if there are more rows in this section, use that.
      return self.section.rows[self.index + 1] if self.index < (self.section.rows.count - 1)

      # if there are more sections, then use the first row of that section.
      return self.section.next_section.rows[0] if self.section.next_section

      nil
    end

    def previous_row
      return self.section.rows[self.index - 1] if self.index > 0

      # if there are more sections, then use the first row of that section.
      return self.section.previous_section.rows[-1] if self.section.previous_section

      nil
    end

    def submit_button?
      object.submit_button?
    end

    #########################
    #  setter overrides
    def type=(type)
      @object = Formotion::RowType.for(type).new(self)
      @type = type
    end

    def return_key=(value)
      @return_key = const_int_get("UIReturnKey", value)
    end

    def auto_correction=(value)
      @auto_correction = const_int_get("UITextAutocorrectionType", value)
    end

    def auto_capitalization=(value)
      @auto_capitalization = const_int_get("UITextAutocapitalizationType", value)
    end

    def clear_button=(value)
      @clear_button = const_int_get("UITextFieldViewMode", value)
    end

    #########################
    # setters for callbacks

    def on_enter(&block)
      self.on_enter_callback = block
    end

    def on_begin(&block)
      self.on_begin_callback = block
    end

    #########################
    # Methods for making cells
    # Called in UITableViewDataSource methods
    # in form_delegate.rb
    def make_cell
      cell, text_field = Formotion::RowCellBuilder.make_cell(self)
      @text_field = text_field
      cell
    end

    #########################
    # Retreiving data
    def to_hash
      super
    end

    private
    def const_int_get(base, value)
      return value if value.is_a? Integer
      value = value.to_s.camelize
      Kernel.const_get("#{base}#{value}")
    end

    # Looks like RubyMotion adds UIKit constants
    # at compile time. If you don't use these
    # directly in your code, they don't get added
    # to Kernel and const_int_get crashes.
    def load_constants_hack
      [UITextAutocapitalizationTypeNone, UITextAutocapitalizationTypeWords,
        UITextAutocapitalizationTypeSentences,UITextAutocapitalizationTypeAllCharacters,
        UITextAutocorrectionTypeNo, UITextAutocorrectionTypeYes, UITextAutocorrectionTypeDefault,
        UIReturnKeyDefault, UIReturnKeyGo, UIReturnKeyGoogle, UIReturnKeyJoin,
        UIReturnKeyNext, UIReturnKeyRoute, UIReturnKeySearch, UIReturnKeySend,
        UIReturnKeyYahoo, UIReturnKeyDone, UIReturnKeyEmergencyCall,
        UITextFieldViewModeNever, UITextFieldViewModeAlways, UITextFieldViewModeWhileEditing,
        UITextFieldViewModeUnlessEditing
      ]
    end
  end
end