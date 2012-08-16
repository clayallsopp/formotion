class UITextView
  attr_reader :placeholder
  attr_accessor :placeholder_color

  alias_method :old_initWithCoder, :initWithCoder
  def initWithCoder(decoder)
    old_initWithCoder(decoder)
    setup
    self
  end

  alias_method :old_initWithFrame, :initWithFrame
  def initWithFrame(frame)
    old_initWithFrame(frame)
    setup
    self
  end

  def setup
    @foreground_observer = NSNotificationCenter.defaultCenter.observe UITextViewTextDidChangeNotification do |notification|
      updateShouldDrawPlaceholder
    end
  end

  alias_method :old_dealloc, :dealloc
  def dealloc
    NSNotificationCenter.defaultCenter.unobserve @foreground_observer
    old_dealloc
  end

  alias_method :old_drawRect, :drawRect
  def drawRect(rect)
    old_drawRect(rect)

    if (@shouldDrawPlaceholder)
        self.placeholder_color.set
        self.placeholder.drawInRect(placeholder_rect, withFont:self.font)
    end
  end


  alias_method :old_setText, :setText
  def setText(text)
    old_setText(text)

    updateShouldDrawPlaceholder
  end

  def placeholder=(placeholder)
    return if @placeholder == placeholder

    @placeholder = placeholder

    updateShouldDrawPlaceholder
  end

  def placeholder_rect
    CGRectMake(self.contentInset.left + 10.0, self.contentInset.top, self.frame.size.width - self.contentInset.left - self.contentInset.right - 16.0, self.frame.size.height - self.contentInset.top - self.contentInset.bottom - 16.0)
  end

  def placeholder_color
    @placeholder_color ||= UIColor.lightGrayColor
  end

  def updateShouldDrawPlaceholder
    prev = @shouldDrawPlaceholder;
    @shouldDrawPlaceholder = self.placeholder && self.text.length == 0

    self.setNeedsDisplay if (prev != @shouldDrawPlaceholder)
  end
end
