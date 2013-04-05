motion_require "../base"

module Formotion
  class Form < Formotion::Base
    extend BubbleWrap::KVO
    include BubbleWrap::KVO

    PROPERTIES = [
      # By default, Formotion::Controller will set it's title to this
      # (so navigation bars will reflect it).
      :title,
      # If you want to have some internal id to track the form.
      :id,
      # [STRING/SYMBOL] used to store your form's state on disk
      :persist_as
    ]
    PROPERTIES.each {|prop|
      attr_accessor prop
    }

    # Sections are create specially using #create_section, so we don't allow
    # them to be pased in the hash
    SERIALIZE_PROPERTIES = PROPERTIES + [:sections]

    def self.persist(params = {})
      form = new(params)
      form.open
      form.init_observer_for_save
      form
    end

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
      hash = hash.merge({:form => self})
      section = Formotion::Section.new(hash)
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
      if @on_submit_callback.nil?
        return
      end

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
            next if row.button?
            if row.templated?
              # If this row is part of a template
              # use the parent's key
              kv[row.template_parent.key] = row.template_parent.value
            else
              kv[row.key] ||= row.value_for_save_hash
            end
          }
        end
      }
      kv.merge! sub_render
      kv.delete_if {|k, v| k.nil? }
      kv
    end

    def sub_render
      kv = {}
      rows = sections.map(&:rows).flatten
      subform_rows = rows.select{ |row| row.subform != nil }
      subform_rows.each do |subform_row|
        kv[subform_row.key] = subform_row.subform.to_form.render
      end
      kv
    end

    def values=(data)
      self.sections.each {|section|
        if section.select_one?
          # see if one of the select one value is used
          unless (section.rows.map{ |r| r.key } & data.keys).empty?
            section.rows.each { |row|
              row.value = data.has_key?(row.key) ? true : nil
            }
          end
        else
          section.rows.each {|row|
            next if row.button?
            if row.template_parent
              # If this row is part of a template
              # use the parent's key
              row.value = data[row.template_parent_key] if data.has_key?(row.template_parent_key)
            elsif row.subform
              row.subform.to_form.values = data
            else
              row.value = data[row.key] if data.has_key?(row.key)
            end
          }
        end
      }
    end

    alias_method :fill_out, :values=

    #########################
    # Persisting Forms

    # loads the given settings into the the form, and
    # places observers to save on changes

    def init_observer_for_save
      @form_save_observer ||= lambda { |form|
        form.sections.each_with_index do |section, s_index|
          section.rows.each_with_index do |row, index|
            if row.subform?
              @form_save_observer.call(row.subform.to_form)
            elsif !row.templated?
              observe(row, "value") do |old_value, new_value|
                self.save
              end
            end
          end
        end
      }

      @form_save_observer.call(self)
    end

    def open
      @form_observer ||= lambda { |form, saved_render|
        form.sections.each_with_index do |section, s_index|
          section.rows.each_with_index do |row, index|
            next if row.templated?
            saved_row_value = saved_render[row.key]

            if row.subform?
              @form_observer.call(row.subform.to_form, saved_row_value)
            elsif row.type == :template
              row.value = saved_row_value
              row.object.update_template_rows
            else
              row.value = saved_row_value
            end
          end
        end
      }
      rendered_data = load_state
      if rendered_data
        @form_observer.call(self, rendered_data)
      else
        save
      end
    end

    # places hash of values into application persistance
    def save
      App::Persistence[persist_key] = render
      App::Persistence[original_persist_key] ||= render
    end

    def reset
      App::Persistence[persist_key] = App::Persistence[original_persist_key]
      open
    end

    private

    def persist_key
      "FORMOTION_#{self.persist_as}"
    end

    def original_persist_key
      "#{persist_key}_ORIGINAL"
    end

    def load_state
      state = App::Persistence[persist_key]
      # support old archived format
      if state.respond_to? :unarchive
        begin
          form = Formotion::Form.new(state.unarchive)
          state = form.render
          p "Old archived data found: #{state}"
        end
      end
      state
    end

    def each_row(&block)
      self.sections.each_with_index do |section, s_index|
        section.rows.each_with_index do |row, index|
          case block.arity
          when 1
            block.call(row)
          when 2
            block.call(row, index)
          end
        end
      end
    end

    def recursive_delete_nil(h)
      delete_empty = Proc.new { |k, v|
        v.delete_if(&delete_empty) if v.kind_of?(Hash)
        v.nil?
      }
      h.delete_if &delete_empty
    end
  end
end
