module Formation
  class RowType
  end

  class RowCellBuilder
  end

  class Row
    PROPERTIES = [:title, :subtitle, 
      :placeholder, :value, 
      :key, :type,
      :switchable, :checkable,
      :editable, :secure, :return_key,
      :auto_correction, :auto_capitalization,
      :clear_button]
    PROPERTIES.each {|prop|
      attr_accessor prop
    }

    attr_reader :field

    attr_accessor :reuse_identifier

    # callbacks
    attr_accessor :on_enter_callback
    attr_accessor :on_begin_callback

    # relations
    attr_accessor :section
    attr_accessor :index
    attr_accessor :next_row
    attr_accessor :previous_row

    def initialize(params = {})
      params.each { |key, value|
        if PROPERTIES.member? key.to_sym
          self.send((key.to_s + "=:").to_sym, value)
        end
      }
    end

    #########################
    # custom getters/setters for type
    def to_hash
      h = {}
      PROPERTIES.each {|prop|
        val = self.send(prop)
        h[prop] = val if val
      }
      h
    end

    def render
      {:key => self.key || self.reuse_identifier, :value => self.value}
    end

    def index_path
      NSIndexPath.indexPathForRow(self.index, inSection:self.section.index)
    end

    def type(type = -10000)
      if type == -10000
        return @type
      end
      self.type = type
    end

    def type=(type)
      if type.class.is_a? Integer
        raise "Type #{type.inspect} is not of class Integer" and return
      end
      @type = type
    end

    def switchable?
      self.switchable
    end

    def checkable?
      self.checkable
    end

    def editable?
      self.editable
    end

    def secure?
      self.secure
    end

    #########################
    # custom getters/setters for callbacks

    def on_enter(&block)
      self.on_enter_callback = block
    end

    def on_begin(&block)
      self.on_begin_callback = block
    end

    #########################
    # Methods for making cells
    def make_cell
      cell, field = Formation::RowCellBuilder.make_cell(self)
      @field = field
      cell
    end
      
    #########################
    # NSCoding
    def encodeWithCoder(encoder)
      PROPERTIES.each {|sym|
        encoder.encodeObject(self.send(sym), forKey: sym.to_s)
      }
    end

    def initWithCoder(decoder)
      if ParseClient.is_mac?
        self.init
      else
        self.init.retain
      end
      PROPERTIES.each {|sym|
        self.send((sym.to_s + "=:").to_sym, decoder.decodeObjectForKey(sym.to_s))
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