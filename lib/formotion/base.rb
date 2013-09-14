motion_require 'row_type/base'

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


    # Needed so things like @targets[target] with KVO
    #  (storing Row instances as keys of a hash)
    def hash
      "#{self.class.name}-id-#{object_id}".hash
    end

    def isEqual(other)
      return true if other == self
      return false unless other # if other is nil
      return false unless other.class == self.class

      return other.object_id == self.object_id
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
