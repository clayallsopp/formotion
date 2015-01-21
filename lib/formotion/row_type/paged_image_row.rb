motion_require 'base'

# ideas taken from:
# http://www.raywenderlich.com/10518/how-to-use-uiscrollview-to-scroll-and-zoom-content

module Formotion
  module RowType
    class PagedImageRow < Base
      TAKE = BW.localized_string("Take", nil)
      DELETE = BW.localized_string("Delete", nil)
      CHOOSE = BW.localized_string("Choose", nil)
      CANCEL = BW.localized_string("Cancel", nil)

      include BW::KVO

      PAGE_VIEW_TAG=1110
      SCROLL_VIEW_TAG=1111

      def build_cell(cell)
        # only show the "plus" when editable
        add_plus_accessory(cell) if row.editable?
        
        self.row.value = [] unless self.row.value.is_a?(Array)
        
        @page_view     = UIPageControl.alloc.init
        @page_view.tag = PAGE_VIEW_TAG
        @page_view.pageIndicatorTintColor        = '#d0d0d0'.to_color
        @page_view.currentPageIndicatorTintColor = '#505050'.to_color
        @page_view.currentPage   = 0
        @page_view.numberOfPages = self.row.value.size
        @page_view.when(UIControlEventValueChanged) do
          page_width = @scroll_view.frame.size.width
          page=@page_view.currentPage
          offset=((page * page_width * 2.0 - page_width) / 2.0) + (page_width/2.0)
          point=@scroll_view.contentOffset
          point.x=offset
          @scroll_view.contentOffset=point
        end
        cell.addSubview(@page_view)
        
        @scroll_view          = UIScrollView.alloc.init
        @scroll_view.tag      = SCROLL_VIEW_TAG
        @scroll_view.delegate = self
        @scroll_view.pagingEnabled        = true
        @scroll_view.delaysContentTouches = true
        @scroll_view.showsHorizontalScrollIndicator=false
        @scroll_view.showsVerticalScrollIndicator=false
        
        pages_size = @scroll_view.frame.size
        @scroll_view.contentSize = CGSizeMake(pages_size.width * self.row.value.size, pages_size.height)
        @page_views = [nil]*self.row.value.size

        cell.addSubview(@scroll_view)

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            
            formotion_field = self.viewWithTag(SCROLL_VIEW_TAG)
            field_frame = formotion_field.frame
            field_frame.origin.y = 10
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + Formotion::RowType::Base.field_buffer
            field_frame.size.width  = self.frame.size.width - field_frame.origin.x - Formotion::RowType::Base.field_buffer
            f_height = self.frame.size.height - 20 - Formotion::RowType::Base.field_buffer
            field_frame.size.height = f_height
            formotion_field.frame = field_frame
            scroll_view=formotion_field
            
            formotion_field = self.viewWithTag(PAGE_VIEW_TAG)
            field_frame = formotion_field.frame
            field_frame.origin.y = 20 + f_height
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + Formotion::RowType::Base.field_buffer
            field_frame.size.width  = self.frame.size.width - field_frame.origin.x - Formotion::RowType::Base.field_buffer
            field_frame.size.height = 10
            formotion_field.frame = field_frame
            
            scroll_view.delegate.resizePages
            scroll_view.delegate.clearPages
          end
        end

	nil
      end

      def on_select(tableView, tableViewDelegate)
        if !row.editable?
          return
        end
      end

      def actionSheet(actionSheet, clickedButtonAtIndex: index)
        if index == actionSheet.destructiveButtonIndex and !@photo_page.nil?
          self.row.value[@photo_page]=nil
          self.row.value.delete(nil)
          self.resizePages
          self.clearPages
          return
        end
    
        source = nil
        case actionSheet.buttonTitleAtIndex(index)
        when TAKE
          source = :camera
        when CHOOSE
          source = :photo_library
        when CANCEL
        end

        if source
          @camera = BW::Device.camera.send((source == :camera) ? :rear : :any)
          @camera.picture(source_type: source, media_types: [:image]) do |result|
            if result[:original_image]
              #-Resize image when requested (no image upscale)
              if result[:original_image].respond_to?(:resize_image_to_size) and row.max_image_size
                result[:original_image]=result[:original_image].resize_image_to_size(row.max_image_size, false)
              end
              # new photo
              if @photo_page.nil?
                self.row.value<<result[:original_image]
              else # or overwrite photo
                self.row.value[@photo_page]=result[:original_image]
              end
              self.resizePages
              self.clearPages
            end
          end
        end
      end

      def add_plus_accessory(cell)
        @add_button ||= begin
          button = UIButton.buttonWithType(UIButtonTypeContactAdd)
          button.accessibilityLabel = BW.localized_string("add image", nil)
          button.when(UIControlEventTouchUpInside) do
            @page_view.becomeFirstResponder
            take_photo
          end
          button
        end
        cell.accessoryView = cell.editingAccessoryView = @add_button
      end
      
      #{{{Paged
      def loadVisiblePages
        # First, determine which page is currently visible
        page_width = @scroll_view.frame.size.width
        page = ((@scroll_view.contentOffset.x * 2.0 + page_width) / (page_width * 2.0)).floor
        # Update the page control
        @page_view.currentPage = page
        # Work out which pages we want to load
        first_page = page - 10
        last_page = page + 1
        # Purge anything before the first page
        0.upto(first_page-1) do |i|
          self.purgePage(i)
        end
        first_page.upto(last_page) do |i|
          self.loadPage(i)
        end
        (last_page+1).upto(self.row.value.size-1) do |i|
          self.purgePage(i)
        end
      end
      
      def get_active_page
        page_width = @scroll_view.frame.size.width
        ((@scroll_view.contentOffset.x * 2.0 + page_width) / (page_width * 2.0)).floor
      end
  
      def pages_single_tap
        page = get_active_page
        if row.editable?
          take_photo(page)
        else
          _on_select(nil, nil)
        end
      end
  
      def take_photo(_page=nil)
        @photo_page=_page
        @action_sheet = UIActionSheet.alloc.init
        @action_sheet.delegate = self
        @action_sheet.destructiveButtonIndex = (@action_sheet.addButtonWithTitle DELETE) unless _page.nil?
        @action_sheet.addButtonWithTitle TAKE if BW::Device.camera.front? or BW::Device.camera.rear?
        @action_sheet.addButtonWithTitle CHOOSE
        @action_sheet.cancelButtonIndex = (@action_sheet.addButtonWithTitle CANCEL)
        @action_sheet.showInView @scroll_view
      end
  
      def clearPages
        0.upto(@page_views.size-1) do |i|
          self.purgePage(i) unless @page_views[i].nil?
        end
        self.loadVisiblePages
      end
  
      def resizePages
        pages_size = @scroll_view.frame.size
        @scroll_view.contentSize = CGSizeMake(pages_size.width * self.row.value.size, pages_size.height)
        #lf = @page_view.frame
        #cf = @page_view.superview.frame
        #old_width = lf.size.width
        #lf.size.width = cf.size.width-(lf.origin.x*2+10*2)
        #@page_view.frame=lf
        #lf.size.width!=old_width
        @page_view.currentPage   = 0
        @page_view.numberOfPages = self.row.value.size
      end
  
      def loadPage(_page)
        if _page < 0 || _page >= self.row.value.size
          # If it's outside the range of what we have to display, then do nothing
          return
        end
        # Load an individual page, first seeing if we've already loaded it
        page_view = @page_views[_page]
        if page_view.nil?
          frame=@scroll_view.bounds
          frame.origin.x = frame.size.width * _page
          frame.origin.y = 0.0
          thumb = self.row.value[_page].resize_image_to_size([frame.size.height,frame.size.height], false)
          new_page_view = UIImageView.alloc.initWithImage(thumb)
          new_page_view.userInteractionEnabled = true
          new_page_view.contentMode = UIViewContentModeScaleAspectFit
          new_page_view.frame = frame
          single_tap = UITapGestureRecognizer.alloc.initWithTarget(self, action:"pages_single_tap")
          single_tap.numberOfTapsRequired = 1
          new_page_view.addGestureRecognizer(single_tap)
          @scroll_view.addSubview(new_page_view)
          @page_views[_page]=new_page_view
        end
      end

      def purgePage(_page)
        if _page < 0 || _page >= self.row.value.size
          # If it's outside the range of what we have to display, then do nothing
          return
        end
        # Remove a page from the scroll view and reset the container array
        page_view = @page_views[_page]
        unless page_view.nil?
          page_view.gestureRecognizers.each do |gr|
            page_view.removeGestureRecognizer(gr)
          end
          page_view.removeFromSuperview
          @page_views[_page]=nil
        end
      end
  
      def scrollViewDidScroll(_scroll_view)
        # Load the pages which are now on screen
        self.loadVisiblePages
      end
      #}}}
      
    end
  end
end
