module Formation
  class Form
    PROPERTIES = [:title, :sections, :id]
    PROPERTIES.each {|prop|
      attr_accessor prop
    }

    def initialize(params = {})
      self.title = params[:title] || params["title"]
      self.id = params[:id] || params["id"] || params["objectId"]

      sections = params[:sections] || params["sections"]
      sections && sections.each_with_index {|section_hash, index|
        section = create_section(section_hash.merge({index: index}))
      }
    end

    def reset
      @sections = []
      @title = nil
    end

    class << self
      def build(&block)
        form = new
        if block.arity == 0
          form.instance_eval &block
        else
          block.call(form)
        end
        form
      end
    end

    def build_section(&block)
      section = create_section
      if block.arity == 0
        section.instance_eval &block
      else
        block.call(section)
      end
      section
    end

    def create_section(hash = {})
      section = Formation::Section.new(hash)
      section.form = self
      section.index = self.sections.count
      section.key ||= section.index.to_s
      self.sections << section
      section
    end

    def sections
      @sections ||= []
    end

    def on_submit(&block)
      @on_submit_callback = block
    end

    def submit
      if @on_submit_callback.arity == 0
        @on_submit_callback.call
      elsif @on_submit_callback.arity == 1
        @on_submit_callback.call(self)
      end
    end

    def row_for_index_path(index_path)
      self.sections[index_path.section].rows[index_path.row]
    end

    def empty?
      (self.title.nil? || self.title.length == 0) and (self.sections.count == 0 || (self.sections.count == 1 && self.sections[0].empty?))
    end
  
    # A complete hashification of the Form
    def to_hash(for_upload = false)
      h = {
        sections: self.sections.collect { |section|
          section.to_hash 
        },
        title: self.title,
        id: self.id
      }
      if for_upload
        h.delete :title
        h.delete :id
      end
      h
    end

    # A hashification with the user's inputted values
    # and row keys.
    def render
      {
        sections: self.sections.collect { |section|
          section.render 
        }
      }
    end
  
    # NSCoding + NSCopying
    def encodeWithCoder(encoder)
      PROPERTIES.each {|prop|
        encoder.encodeObject(self.send(prop), forKey: prop.to_s)
      }
    end
  
    def initWithCoder(decoder)
      self.init
      PROPERTIES.each {|prop|
        self.send((prop.to_s + "=:").to_sym, decoder.decodeObjectForKey(prop.to_s))
      }
      self
    end
  
    def copyWithZone(zone)
      copy = self.class.allocWithZone(zone).init
      PROPERTIES.each {|prop|
        copy.send((prop.to_s + "=:").to_sym, self.send(prop))
      }
      copy
    end
  end
end