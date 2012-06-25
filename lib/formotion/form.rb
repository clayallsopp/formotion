module Formotion
  class Form < Formotion::Base
    PROPERTIES = [
      # By default, Formotion::Controller will set it's title to this
      # (so navigation bars will reflect it).
      :title, 
      # If you want to have some internal id to track the form.
      :id
    ]
    PROPERTIES.each {|prop|
      attr_accessor prop
    }

    # Sections are create specially using #create_section, so we don't allow
    # them to be pased in the hash
    SERIALIZE_PROPERTIES = PROPERTIES + [:sections]

    def initialize(params = {})
      # super takes care of initializing the ::PROPERTIES in params
      super

      sections = params[:sections] || params["sections"]
      sections && sections.each_with_index {|section_hash, index|
        section = create_section(section_hash.merge({index: index}))
      }
    end

    # Use this as a DSL for building forms
    # EX
    # @form = Form.build do |form|
    #   form.title = 'Form Title'
    #   form.id = 'anything'
    # end
    class << self
      def build(&block)
        form = new
        block.call(form)
        form
      end
    end

    # Use this as a DSL for adding sections
    # EX
    # @form.build_section do |section|
    #   section.title = 'Section Title'
    # end
    def build_section(&block)
      section = create_section
      block.call(section)
      section
    end

    # Use this to add sections via a hash
    # EX
    # @form.create_section(:title => 'Section Title')
    def create_section(hash = {})
      section = Formotion::Section.new(hash)
      section.form = self
      section.index = self.sections.count
      self.sections << section
      section
    end

    #########################
    #  attributes

    def sections
      @sections ||= []
    end

    def sections=(sections)
      sections.each {|section|
        Formotion::Conditions.assert_class(section, Formotion::Section)
      }
      @sections = sections
    end

    # Accepts an NSIndexPath and gives back a Formotion::Row
    # EX
    # row = @form.row_for_index_path(NSIndexPath.indexPathForRow(0, inSection: 0))
    def row_for_index_path(index_path)
      self.sections[index_path.section].rows[index_path.row]
    end

    #########################
    #  callbacks

    # Stores the callback block when you do #submit.
    # EX
    # @form.on_submit do 
    #   do_something(@form.render)
    # end
    #
    # EX
    # @form.on_submit do |form|
    #   pass_to_server(form.render)
    # end
    def on_submit(&block)
      @on_submit_callback = block
    end

    # Triggers the #on_submit block
    # Handles either zero or one arguments,
    # as shown above.
    def submit
      if @on_submit_callback.arity == 0
        @on_submit_callback.call
      elsif @on_submit_callback.arity == 1
        @on_submit_callback.call(self)
      end
    end
  
    #########################
    # Retreiving data

    # A complete hashification of the Form
    # EX
    # @form = Formotion::Form.new(title: 'My Title')
    # @form.id = 'anything'
    # @form.to_hash
    # => {title: 'My Title', id: 'anything'}
    def to_hash
      # super handles all of the ::PROPERTIES
      h = super
      h[:sections] = self.sections.collect { |section|
        section.to_hash 
      }
      recursive_delete_nil(h)
      h
    end

    # A hashification with the user's inputted values
    # and row keys.
    # EX
    # @form = Formotion::Form.new(sections: [{
    #  rows: [{
    #    key: 'Email', 
    #    editable: true, 
    #    title: 'Email'
    #  }]}])
    # ...user plays with the Form...
    # @form.render
    # => {email: 'something@email.com'}
    def render
      kv = {}
      self.sections.each {|section|
        if section.select_one?
          section.rows.each {|row|
            if row.value
              kv[section.key] = row.key
            end
          }
        else
          section.rows.each {|row|
            next if row.submit_button?
            kv[row.key] = row.value
          }
        end
      }
      kv.delete_if {|k, v| k.nil? }
      kv
    end

    private
    def recursive_delete_nil(h)
      delete_empty = Proc.new { |k, v|
        v.delete_if(&delete_empty) if v.kind_of?(Hash)
        v.nil?
      }
      h.delete_if &delete_empty
    end
  end
end