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
      # Stores possible date pickers mode; corresponds to UIDatePickerMode______
      # OPTIONS: :time, :date, :date_time, :countdown
      # DEFAULT is :date
      :picker_mode,
      # Stores possible formatting information (used by date pickers, etc)
      #   if :type == :date, accepts values in [:short, :medium, :long, :full]
      :format,
      # alternative title for row (only used in EditRow for now)
      :alt_title,

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
      :clear_button,
      # row height as integer; used for heightForRowAtIndexPath
      # EX 200
      # DEFAULT is nil, which is used as the tableView.row_height
      :row_height,
      # range used for slider min and max value
      # EX (1..100)
      # DEFAULT is (1..10)
      :range,
      # Array used for control row items
      # EX ['free', 'pro']
      # DEFAULT is []
      :items,
      # A hash for a Form used for subforms
      # DEFAULT is nil
      :subform,
      # Used in a subform row; when given,
      # will display the value of the matching key
      # of the subform's rendering.
      # DEFAULT is nil
      :display_key,
      # A hash for a Row used for templates
      # DEFAULT is nil
      :template,
      # Indents row when set to true
      # DEFAULT is false
      :indented,
      # Shows a delete sign next to the row
      # DEFAULT is false
      :deletable,
      # When a row is deleted, actually remove the row from UI
      # instead of just nil'ing the value.
      # DEFAULT is false EXCEPT for template-generated rows
      :remove_on_delete
    ]
    PROPERTIES.each {|prop|
      attr_accessor prop
    }
    BOOLEAN_PROPERTIES = [:secure, :indented, :deletable, :remove_on_delete]
    BOOLEAN_PROPERTIES.each { |prop|
      alias_method "#{prop}?", prop
    }
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
    # callback for what happens when the user
    # taps a ButtonRow
    attr_accessor :on_tap_callback

    # RowType object
    attr_accessor :object

    # Owning template row, if applicable
    attr_accessor :template_parent

    def initialize(params = {})
      super

      BOOLEAN_PROPERTIES.each { |prop|
        Formotion::Conditions.assert_nil_or_boolean(self.send(prop))
      }
    end

    # called after section and index have been assigned
    def after_create
      if self.type == :template and (self.value && self.value.any?)
        self.value.each do |value|
          new_row = self.object.build_new_row({:value => value})
        end
      end
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
      @reuse_identifier || "Formotion_#{self.object_id}"
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

    def button?
      object.button?
    end

    def subform?
      self.type == :subform
    end

    #########################
    #  getter overrides
    def items
      if @items.respond_to?(:call)
        @items = @items.call
      end
      @items
    end

    #########################
    #  setter overrides
    def type=(type)
      @object = Formotion::RowType.for(type).new(self)
      @type = type
    end

    def range=(range)
      if range
        case range
        when Range
          # all good
        when Array
          range = Range.new(range[0], range[1])
        else
          raise Formotion::InvalidClassError, "Attempted Row.range = #{range.inspect} should be of type Range or Array"
        end
      end
      @range = range
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

    # Used in :button type rows
    def on_tap(&block)
      self.on_tap_callback = block
    end

    #########################
    # Methods for making cells
    # Called in UITableViewDataSource methods
    # in form_delegate.rb
    def make_cell
      if self.object.nil?
        raise Formotion::NoRowTypeError, "No row type specified for row #{self.index_path.row} in section #{self.index_path.section}; specify a :type"
      end
      cell, text_field = Formotion::RowCellBuilder.make_cell(self)
      @text_field = text_field
      self.object.after_build(cell)
      cell
    end

    # Called on every tableView:cellForRowAtIndexPath:
    # so keep implementation details minimal
    def update_cell(cell)
      self.object.update_cell(cell)
      cell
    end

    #########################
    # Retreiving data
    def to_hash
      h = super
      if h[:range] && h[:range].is_a?(Range)
        h[:range] = [self.range.begin, self.range.end]
      end
      if subform?
        h[:subform] = self.subform.to_form.to_hash
      end
      h
    end

    def subform=(subform)
      @subform = subform
      # enables you do to row.subform.to_form
      @subform.instance_eval do
        def to_form
          return @hash_subform if @hash_subform
          if self.is_a? Hash
            @hash_subform = Formotion::Form.new(self)
          elsif not self.is_a? Formotion::Form
            raise Formotion::InvalidClassError, "Attempted subform = '#{self.inspect}' should be of type Formotion::Form or Hash"
          end
          @hash_subform ||= self
        end
      end
      @subform
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
        UITextFieldViewModeUnlessEditing, NSDateFormatterShortStyle, NSDateFormatterMediumStyle,
        NSDateFormatterLongStyle, NSDateFormatterFullStyle
      ]
    end
  end
end
