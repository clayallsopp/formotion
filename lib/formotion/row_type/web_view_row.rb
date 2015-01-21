motion_require 'base'

module Formotion
  module RowType
    class WebViewRow < Base
      include BW::KVO

      WEB_VIEW_TAG=1100

      def set_page
        if row.value =~/^https?:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?\/?([a-zA-Z0-9\-\._\?\,\'\/\+&%\$#\=~])*$/
          @loading = true
          req = NSURLRequest.requestWithURL(NSURL.URLWithString(row.value))
          @web_view.loadRequest(req)
        else
          @web_view.loadHTMLString(row.value, baseURL:nil) if row.value
          @loading = false
        end
      end
      
      def stringByEvaluatingJavaScriptFromString(script)
        @web_view.stringByEvaluatingJavaScriptFromString(script)
      end
      
      def loading
        @loading
      end

      def build_cell(cell)
        cell.selectionStyle = self.row.selection_style || UITableViewCellSelectionStyleBlue
        
        @loading = true
        @web_view = UIWebView.alloc.init
        @web_view.delegate = self
        set_page
        
        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            set_page
          end
        end
        
        @web_view.tag = WEB_VIEW_TAG
        @web_view.contentMode = UIViewContentModeScaleAspectFit
        @web_view.backgroundColor = UIColor.clearColor
        cell.addSubview(@web_view)

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            formotion_field = self.viewWithTag(WEB_VIEW_TAG)

            field_frame = formotion_field.frame
            field_frame.origin.y = 10
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + Formotion::RowType::Base.field_buffer
            field_frame.size.width  = self.frame.size.width - field_frame.origin.x - Formotion::RowType::Base.field_buffer
            field_frame.size.height = self.frame.size.height - Formotion::RowType::Base.field_buffer
            formotion_field.frame = field_frame
          end
        end

	nil
      end

      def on_select(tableView, tableViewDelegate)
        if !row.editable?
          return
        end
      end
      
      #def webView(web_view, didFailLoadWithError:error)
      #end

      #def webViewDidStartLoad(web_view)
      #end

      def webViewDidFinishLoad(web_view)
        @loading = false
      end
      
    end
  end
end
