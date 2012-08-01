module Formotion
  class Section < Formotion::Base
    PROPERTIES = [
      # Displayed in the section header row
      :title,
      # Displayed below the entire section; good for giving
      # detailed information regarding the section.
      :footer,
      # Arranges the section as a 'radio' section,
      # such that only one row can be checked at a time.
      :select_one,
      # IF :select_one is true, then @form.render will contain
      # the checked row's value as the value for this key.
      # ELSE it does nothing.
      :key
    ]
    PROPERTIES.each {|prop|
      attr_accessor prop
    }
    SERIALIZE_PROPERTIES = PROPERTIES + [:rows]

    # Relationships

    # This section's form
    attr_accessor :form

    # This section's index in it's form.
    attr_accessor :index

    def initialize(params = {})
      super

      Formotion::Conditions.assert_nil_or_boolean(self.select_one)

      rows = params[:rows] || params["rows"]
      rows && rows.each {|row_hash|
        row = create_row(row_hash)
      }
    end

    def build_row(&block)
      row = create_row
      block.call(row)
      row
    end

    def create_row(hash = {})
      row = hash
      if hash.class == Hash
        row = Formotion::Row.new(hash)
      end
      row.section = self
      row.index = self.rows.count
      # dont move to after the appending.
      row.after_create
      self.rows << row
      row
    end

    #########################
    #  attribute overrides

    def rows
      @rows ||= []
    end

    def rows=(rows)
      rows.each {|row|
        Formotion::Conditions.assert_class(row, Formotion::Row)
      }
      @rows = rows
    end

    def index=(index)
      @index = index.to_i
    end

    #########################
    # pseudo-properties

    # should be done with alias_method but there's currently a bug
    # in RM which messes up attr_accessors with alias_method
    def select_one?
      self.select_one
    end

    def next_section
      # if there are more sections in this form, use that.
      if self.index < self.form.sections.count - 1
        return self.form.sections[self.index + 1]
      end

      nil
    end

    def previous_section
      # if there are more sections in this form, use that.
      if self.index > 0
        return self.form.sections[self.index - 1]
      end

      nil
    end

    def refresh_row_indexes
      rows.each_with_index do |row, index|
        row.index = index
      end
    end

    #########################
    # Retreiving data
    def to_hash
      h = super
      h[:rows] = self.rows.collect {|row| row.to_hash}
      h
    end
  end
end