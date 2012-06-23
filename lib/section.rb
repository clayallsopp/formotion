module Formation
  class Section
    PROPERTIES = [:key, :title, :select_one]
    PROPERTIES.each {|prop|
      attr_accessor prop
    }

    # relations
    attr_accessor :form
    attr_accessor :index
    attr_writer :rows

    def initialize(params = {})
      params.each {|key, value|
        if PROPERTIES.member? key.to_sym
          self.send((key.to_s + "=:").to_sym, value)
          next
        end
        if key.to_s == "index"
          self.index = value.to_i
        end
      }

      rows = params[:rows] || params["rows"]
      rows && rows.each {|row_hash|
        row = create_row(row_hash)
      }
    end

    def build_row(&block)
      row = create_row
      if block.arity == 0
        row.instance_eval &block
      else
        block.call(row)
      end
      row
    end

    def create_row(hash = {})
      row = hash
      if hash.class == Hash
        row = Formation::Row.new(hash)
      end
      row.section = self
      row.index = self.rows.count
      row.reuse_identifier ||= "SECTION_#{self.index}_ROW_#{row.index}"
      self.rows << row
      row
    end

    def rows
      @rows ||= []
    end
    
    def empty?
      (self.title.nil? || self.title.length == 0) and self.rows.count == 0
    end
    
    def to_hash
      h = {}
      PROPERTIES.each {|prop|
        val = self.send(prop)
        h[prop] = val if val
      }
      h[:rows] = self.rows.collect {|row| row.to_hash}
      h
    end

    def render
      {:key => self.key, :rows => self.rows.collect {|row| row.render}}
    end
    
    # NSCoding + NSCopying
    def encodeWithCoder(encoder)
      [PROPERTIES, :rows].flatten.each {|prop|
        encoder.encodeObject(self.send(prop), forKey: prop.to_s)
      }
    end
    
    def initWithCoder(decoder)
      self.init
      [PROPERTIES, :rows].flatten.each {|prop|
        self.send((prop.to_s + "=:").to_sym, decoder.decodeObjectForKey(prop.to_s))
      }
      self
    end
    
    def copyWithZone(zone)
      copy = self.class.allocWithZone(zone).init
      [PROPERTIES, :rows].flatten.each {|prop|
        copy.send((prop.to_s + "=:").to_sym, self.send(prop))
      }
      copy
    end
  end
end