# To make accessibility labels work in UIActionSheets
# adapted from https://gist.github.com/953326

class UIActionSheet

  alias_method :old_addButtonWithTitle, :addButtonWithTitle

  def addButtonWithTitle(title)
    button_index = old_addButtonWithTitle(title)
    self.subviews.each { |subview|
      if subview.respond_to? :title
        controlTitle = subview.send(:title)
        if (title == controlTitle)
          copyAccessibilityMetadataFrom(title, toControl: subview)
          return button_index
        end
      end
    }
    button_index
  end

  private
  def copyAccessibilityMetadataFrom(title, toControl:control)
    control.accessibilityLabel = title
  end

end