module Formotion
  class Base
    def initialize(params = {})
      params.each { |key, value|
        if  self.class.const_get(:PROPERTIES).member? key.to_sym
          self.send("#{key}=".to_sym, value)
        end
      }
    end

    def to_hash
      h = {}
       self.class.const_get(:PROPERTIES).each { |prop|
        val = self.send(prop)
        h[prop] = val if val
      }
      h
    end

    # NSCoding + NSCopying
    def encodeWithCoder(encoder)
      self.class.const_get(:SERIALIZE_PROPERTIES).each {|prop|
        encoder.encodeObject(self.send(prop), forKey: prop.to_s)
      }
    end

    def initWithCoder(decoder)
      self.init
      self.class.const_get(:SERIALIZE_PROPERTIES).each {|prop|
        value = decoder.decodeObjectForKey(prop.to_s)
        self.send("#{prop}=".to_sym, value) if not value.nil?
      }
      self
    end

    def copyWithZone(zone)
      copy = self.class.allocWithZone(zone).init
      self.class.const_get(:SERIALIZE_PROPERTIES).each {|prop|
        copy.send("#{prop}=".to_sym, self.send(prop))
      }
      copy
    end
  end
end