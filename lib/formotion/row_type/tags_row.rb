motion_require 'base'

# ideas and images taken from:
# https://github.com/davbeck/TURecipientBar
# License: https://github.com/davbeck/TURecipientBar/blob/master/LICENSE.md

module Formotion
  module RowType
    class TagsRow < Base
      include BW::KVO

      TAGS_VIEW_TAG=1110
      TAGS_EDIT_VIEW_TAG=1111

      def build_cell(cell)
        # only show the "plus" when editable
        add_plus_accessory(cell) if row.editable?
        
        self.row.value = [] unless self.row.value.is_a?(Array)
        
        @scroll_view          = UIScrollView.alloc.init
        @scroll_view.tag      = row.editable? ? TAGS_EDIT_VIEW_TAG : TAGS_VIEW_TAG
        @scroll_view.delegate = self
        @scroll_view.pagingEnabled        = false
        @scroll_view.delaysContentTouches = true
        @scroll_view.showsHorizontalScrollIndicator = false
        @scroll_view.showsVerticalScrollIndicator   = false
        @btns = {}
        cell.addSubview(@scroll_view)
        
        row.value.each do |t|
          add_tag(t)
        end

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            edittable = false
            formotion_field = self.viewWithTag(TAGS_VIEW_TAG)
            # is an editable row
            if formotion_field.nil?
              edittable = true
              formotion_field = self.viewWithTag(TAGS_EDIT_VIEW_TAG)
            end
            field_frame = formotion_field.frame
    
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + Formotion::RowType::Base.field_buffer
            edit_buffer = edittable ? 20.0 : 0.0
            field_frame.size.width  = self.frame.size.width - field_frame.origin.x - Formotion::RowType::Base.field_buffer - edit_buffer
            
            # rearrange the tags
            last = CGRectMake(0.0, 0.0, 0.0, 0.0)
            formotion_field.subviews.each do |sv|
              now = sv.frame
              now.origin.x = (last.origin.x+last.size.width)+5.0
              now.origin.y = last.origin.y
              if (now.origin.x+now.size.width)+3.0 > field_frame.size.width
                now.origin.x = 5.0
                now.origin.y += last.size.height + 5.0
              end
              sv.frame = now
              last = now
            end
            
            # set the height of the scroll box
            max_height = self.frame.size.height - 3.0
            field_frame.size.height = last.origin.y + last.size.height + 5.0
            field_frame.size.height = max_height if field_frame.size.height > max_height
            field_frame.origin.y = (self.frame.size.height - field_frame.size.height) / 2.0
            
            formotion_field.frame = field_frame
            
          end
        end
      end
      
      def _on_select(tableView, tableViewDelegate)
      end

      def add_plus_accessory(cell)
        @add_button ||= begin
          button = UIButton.buttonWithType(UIButtonTypeContactAdd)
          button.accessibilityLabel = BW.localized_string("add tag", nil)
          button.when(UIControlEventTouchUpInside) do
            if row.on_tap_callback
              row.on_tap_callback.call(self.row)
            end
          end
          button
        end
        cell.accessoryView = cell.editingAccessoryView = @add_button
      end
      
      def image_for_state(state)
        case state
        when UIControlStateNormal
          return UIImage.imageNamed("tags_row.png").stretchableImageWithLeftCapWidth(14, topCapHeight:0)
          
        when UIControlStateHighlighted, UIControlStateSelected
          return UIImage.imageNamed("tags_row-selected.png").stretchableImageWithLeftCapWidth(14, topCapHeight:0)
                    
        end
        nil
      end
      
      def attrib_for_state(state)
        case state
        when UIControlStateNormal
          return { NSFontAttributeName => UIFont.systemFontOfSize(14.0),
                   NSForegroundColorAttributeName => UIColor.blackColor }
          
        when UIControlStateHighlighted, UIControlStateSelected
          return { NSFontAttributeName => UIFont.systemFontOfSize(14.0),
                   NSForegroundColorAttributeName => UIColor.whiteColor }
                   
        end
      end
      
      def add_tag(text)
        return if @btns.has_key?(text)
      	btn = UIButton.buttonWithType(UIButtonTypeCustom)
      	btn.adjustsImageWhenHighlighted = false
      	btn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)
        textsize = text.sizeWithFont(UIFont.systemFontOfSize(14.0))
        width = textsize.width+14.0
        btn.frame = CGRectMake(0.0, 0.0, width, 24.0)
        [UIControlStateNormal, UIControlStateHighlighted, UIControlStateSelected].each do |state|
      	  btn.setBackgroundImage(image_for_state(state), forState:state)
          attr_text = NSAttributedString.alloc.initWithString(text, attributes:attrib_for_state(state))          
          btn.setAttributedTitle(attr_text, forState:state)
        end

        if row.editable?
          btn.addTarget(self, action:'button_click:', forControlEvents:UIControlEventTouchUpInside)
        end
    
      	btn.translatesAutoresizingMaskIntoConstraints = false
      	@scroll_view.addSubview(btn)
        unless row.value.include?(text)
          row.value << text
        end
        @btns[text] = btn
      end
    
      def button_click(btn)
        @del_btn = btn
        App.alert(BW.localized_string("Remove Tag?"), cancel_button_title: NO) do |alert|
          alert.addButtonWithTitle(YES)
          alert.delegate = self
        end
      end
      
      YES = BW.localized_string("Yes", nil)
      NO = BW.localized_string("No", nil)

      def alertView(alert_view, clickedButtonAtIndex:button_index)
        if alert_view.buttonTitleAtIndex(button_index)==NO
          @del_btn = nil
          return
        end 
        @del_btn.removeFromSuperview
        @btns.delete(@del_btn)
        row.value.delete(@del_btn.currentAttributedTitle.string)
      end
  
      def scrollViewDidScroll(_scroll_view)
      end
      
    end
  end
end
