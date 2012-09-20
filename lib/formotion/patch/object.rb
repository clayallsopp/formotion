class Object
  # Creates an alias for :method with the form
  # old_#{method}
  # Instance evals the block.
  def swizzle(method, &block)
    self.class.send(:alias_method, "old_#{method.to_s}".to_sym, method)
    self.instance_eval &block
  end

  def to_archived_data
    NSKeyedArchiver.archivedDataWithRootObject(self)
  end
end

class NSData
  def unarchive
    NSKeyedUnarchiver.unarchiveObjectWithData(self)
  end
end
